import {
  BaseConfig,
  type ConfigReturn,
  type ContextBuilder,
  type Dpp,
  type MultipleHook,
  type Plugin,
} from "jsr:@shougo/dpp-vim@~2.0.0/types";
import { mergeFtplugins } from "jsr:@shougo/dpp-vim@~2.0.0/utils";

import type { Denops } from "jsr:@denops/std@~7.0.1";
import * as fn from "jsr:@denops/std@~7.0.1/function";

import { expandGlob } from "jsr:@std/fs@~1.0.0/expand-glob";

type Toml = {
  hooks_file?: string;
  ftplugins?: Record<string, string>;
  multiple_hooks?: MultipleHook[];
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
    } else if (!hasNvim) {
      if (await fn.has(args.denops, "gui_running")) {
        inlineVimrcs.push("$BASE_DIR/gui.rc.vim");
      }
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
    const protocols = await args.dpp.getProtocols(args.denops, options);

    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];
    let multipleHooks: MultipleHook[] = [];

    const [tomlExt, tomlOptions, tomlParams] = await args.dpp.getExt(
      args.denops,
      options,
      "toml",
    );
    if (tomlExt) {
      const action = tomlExt.actions["load"];

      const tomlPromises = [
        { path: "$BASE_DIR/merge.toml", lazy: false },
        { path: "$BASE_DIR/dpp.toml", lazy: false },
        { path: "$BASE_DIR/lazy.toml", lazy: true },
        { path: "$BASE_DIR/denops.toml", lazy: true },
        { path: "$BASE_DIR/ddc.toml", lazy: true },
        { path: "$BASE_DIR/ddu.toml", lazy: true },
        { path: "$BASE_DIR/ddx.toml", lazy: true },
        {
          path: hasNvim ? "$BASE_DIR/neovim.toml" : "$BASE_DIR/vim.toml",
          lazy: true,
        },
      ].map((tomlFile) =>
        action.callback({
          denops: args.denops,
          context,
          options,
          protocols,
          tomlOptions,
          tomlParams,
          actionParams: {
            path: tomlFile.path,
            options: {
              lazy: tomlFile.lazy,
            },
          },
        }) as Promise<Toml | undefined>
      );

      const tomls: (Toml | undefined)[] = await Promise.all(tomlPromises);

      // Merge toml results
      for (const toml of tomls) {
        if (!toml) {
          continue;
        }

        for (const plugin of toml.plugins ?? []) {
          recordPlugins[plugin.name] = plugin;
        }

        if (toml.ftplugins) {
          mergeFtplugins(ftplugins, toml.ftplugins);
        }

        if (toml.multiple_hooks) {
          multipleHooks = multipleHooks.concat(toml.multiple_hooks);
        }

        if (toml.hooks_file) {
          hooksFiles.push(toml.hooks_file);
        }
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

    const checkFiles = [];
    for await (const file of expandGlob(`${Deno.env.get("BASE_DIR")}/*`)) {
      checkFiles.push(file.path);
    }

    return {
      checkFiles,
      ftplugins,
      hooksFiles,
      multipleHooks,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
