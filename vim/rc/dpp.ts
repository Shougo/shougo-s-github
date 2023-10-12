import {
  BaseConfig,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.0.3/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v0.0.3/deps.ts";


export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
    dpp: Dpp;
  }): Promise<{
    plugins: Plugin[];
    stateLines: string[];
  }> {
    const inlineVimrcs = [
      "$BASE_DIR/options.rc.vim",
      "$BASE_DIR/mappings.rc.vim",
    ];
    if (args.denops.meta.host === "nvim") {
      inlineVimrcs.push("$BASE_DIR/neovim.rc.vim");
    } else if (await fn.has(args.denops, "gui_running")) {
      inlineVimrcs.push("$BASE_DIR/gui.rc.vim");
    }
    if (await fn.has(args.denops, "win32")) {
      inlineVimrcs.push("$BASE_DIR/windows.rc.vim");
    } else {
      inlineVimrcs.push("$BASE_DIR/unix.rc.vim");
    }

    args.contextBuilder.setGlobal({
      inlineVimrcs,
      protocols: ["git"],
    });

    const [context, options] = await args.contextBuilder.get(args.denops);

    const tomlPlugins = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "toml",
      "load",
      {
        path: "$BASE_DIR/deinlazy.toml",
        options: {
          lazy: true,
        },
      },
    ) as Plugin[];

    const recordPlugins: Record<string, Plugin> = {};
    for (const plugin of tomlPlugins) {
      recordPlugins[plugin.name] = plugin;
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
    ) as Plugin[];

    // Merge localPlugins
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

    const stateLines = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(recordPlugins),
      },
    ) as string[];

    return {
      checkFiles: await fn.globpath(
        args.denops,
        Deno.env.get("BASE_DIR"),
        "*",
        1,
        1,
      ),
      plugins: Object.values(recordPlugins),
      stateLines,
    };
  }
}
