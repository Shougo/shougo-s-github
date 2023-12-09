import {
  BaseConfig,
  ConfigReturn,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.0.9/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v0.0.9/deps.ts";

type Toml = {
  hooks_file?: string;
  ftplugins?: Record<string, string>;
  plugins?: Plugin[];
};

type LazyMakeStateResult = {
  plugins: Plugin[];
  stateLines: string[];
};

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
    dpp: Dpp;
  }): Promise<ConfigReturn> {
    const hasNvim = args.denops.meta.host === "nvim";
    const hasWindows = await fn.has(args.denops, "win32");

    const inlineVimrcs = [
      "$BASE_DIR/options.rc.vim",
      "$BASE_DIR/mappings.rc.vim",
      "$BASE_DIR/filetype.rc.vim",
    ];
    if (hasNvim) {
      inlineVimrcs.push("$BASE_DIR/neovim.rc.vim");
    } else if (await fn.has(args.denops, "gui_running")) {
      inlineVimrcs.push("$BASE_DIR/gui.rc.vim");
    }
    if (hasWindows) {
      inlineVimrcs.push("$BASE_DIR/windows.rc.vim");
    } else {
      inlineVimrcs.push("$BASE_DIR/unix.rc.vim");
    }

    args.contextBuilder.setGlobal({
      inlineVimrcs,
      extParams: {
        installer: {
          checkDiff: true,
          logFilePath: "~/.cache/dpp/installer-log.txt",
          githubAPIToken: Deno.env.get("GITHUB_API_TOKEN"),
        },
      },
      protocols: ["git"],
    });

    const [context, options] = await args.contextBuilder.get(args.denops);

    // Load toml plugins
    const tomls: Toml[] = [];
    for (
      const tomlFile of [
        "$BASE_DIR/merge.toml",
        "$BASE_DIR/dpp.toml",
      ]
    ) {
      const toml = await args.dpp.extAction(
        args.denops,
        context,
        options,
        "toml",
        "load",
        {
          path: tomlFile,
          options: {
            lazy: false,
          },
        },
      ) as Toml | undefined;

      if (toml) {
        tomls.push(toml);
      }
    }
    for (
      const tomlFile of [
        "$BASE_DIR/lazy.toml",
        "$BASE_DIR/denops.toml",
        "$BASE_DIR/ddc.toml",
        "$BASE_DIR/ddu.toml",
        hasNvim ? "$BASE_DIR/neovim.toml" : "$BASE_DIR/vim.toml",
      ]
    ) {
      const toml = await args.dpp.extAction(
        args.denops,
        context,
        options,
        "toml",
        "load",
        {
          path: tomlFile,
          options: {
            lazy: true,
          },
        },
      ) as Toml | undefined;

      if (toml) {
        tomls.push(toml);
      }
    }

    // Merge toml results
    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];
    for (const toml of tomls) {
      for (const plugin of toml.plugins ?? []) {
        recordPlugins[plugin.name] = plugin;
      }

      if (toml.ftplugins) {
        for (const filetype of Object.keys(toml.ftplugins)) {
          if (ftplugins[filetype]) {
            ftplugins[filetype] += `\n${toml.ftplugins[filetype]}`;
          } else {
            ftplugins[filetype] = toml.ftplugins[filetype];
          }
        }
      }

      if (toml.hooks_file) {
        hooksFiles.push(toml.hooks_file);
      }
    }

    const localPlugins = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "local",
      "local",
      {
        directory: "~/work",
        options: {
          frozen: true,
          merged: false,
        },
        includes: [
          "vim*",
          "nvim-*",
          "*.vim",
          "*.nvim",
          "ddc-*",
          "ddu-*",
          "dpp-*",
          "skkeleton",
          "neco-vim",
        ],
      },
    ) as Plugin[] | undefined;

    if (localPlugins) {
      for (const plugin of localPlugins) {
        if (plugin.name in recordPlugins) {
          recordPlugins[plugin.name] = Object.assign(
            recordPlugins[plugin.name],
            plugin,
          );
        } else {
          recordPlugins[plugin.name] = plugin;
        }
      }
    }

    const packSpecPlugins = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "packspec",
      "load",
      {
        basePath: args.basePath,
        plugins: Object.values(recordPlugins),
      },
    ) as Plugin[] | undefined;
    if (packSpecPlugins) {
      for (const plugin of packSpecPlugins) {
        if (plugin.name in recordPlugins) {
          recordPlugins[plugin.name] = Object.assign(
            recordPlugins[plugin.name],
            plugin,
          );
        } else {
          recordPlugins[plugin.name] = plugin;
        }
      }
    }
    //console.log(packSpecPlugins);

    const lazyResult = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(recordPlugins),
      },
    ) as LazyMakeStateResult | undefined;

    return {
      checkFiles: await fn.globpath(
        args.denops,
        Deno.env.get("BASE_DIR"),
        "*",
        1,
        1,
      ) as unknown as string[],
      ftplugins,
      hooksFiles,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
