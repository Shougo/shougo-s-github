import type { ContextBuilder, ExtOptions, Plugin } from "@shougo/dpp-vim/types";
import {
  BaseConfig,
  type ConfigReturn,
  type MultipleHook,
} from "@shougo/dpp-vim/config";
import { Protocol } from "@shougo/dpp-vim/protocol";
import { mergeFtplugins } from "@shougo/dpp-vim/utils";

import type {
  Ext as TomlExt,
  Params as TomlParams,
} from "@shougo/dpp-ext-toml";
import type {
  Ext as LocalExt,
  Params as LocalParams,
} from "@shougo/dpp-ext-local";
import type {
  Ext as PackspecExt,
  Params as PackspecParams,
} from "@shougo/dpp-ext-packspec";
import type {
  Ext as LazyExt,
  LazyMakeStateResult,
  Params as LazyParams,
} from "@shougo/dpp-ext-lazy";

import type { Denops } from "@denops/std";
import * as fn from "@denops/std/function";

import { expandGlob } from "@std/fs/expand-glob";

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
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
    const protocols = await args.denops.dispatcher.getProtocols() as Record<
      string,
      Protocol
    >;

    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];
    let multipleHooks: MultipleHook[] = [];

    const [tomlExt, tomlOptions, tomlParams]: [
      TomlExt | undefined,
      ExtOptions,
      TomlParams,
    ] = await args.denops.dispatcher.getExt(
      "toml",
    ) as [TomlExt | undefined, ExtOptions, TomlParams];
    if (tomlExt) {
      const action = tomlExt.actions.load;

      const tomlPromises = [
        { path: "$BASE_DIR/merge.toml", lazy: false },
        { path: "$BASE_DIR/dpp.toml", lazy: false },
        { path: "$BASE_DIR/lazy.toml", lazy: true },
        { path: "$BASE_DIR/denops.toml", lazy: true },
        { path: "$BASE_DIR/ddc.toml", lazy: true },
        { path: "$BASE_DIR/ddu.toml", lazy: true },
        { path: "$BASE_DIR/ddx.toml", lazy: true },
        { path: "$BASE_DIR/ddt.toml", lazy: true },
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
          extOptions: tomlOptions,
          extParams: tomlParams,
          actionParams: {
            path: tomlFile.path,
            options: {
              lazy: tomlFile.lazy,
            },
          },
        })
      );

      const tomls = await Promise.all(tomlPromises);

      // Merge toml results
      for (const toml of tomls) {
        for (const plugin of toml.plugins ?? []) {
          recordPlugins[plugin.name] = plugin;
        }

        if (toml.ftplugins) {
          mergeFtplugins(ftplugins, toml.ftplugins);
        }

        if (toml.multiple_hooks) {
          multipleHooks = [...multipleHooks, ...toml.multiple_hooks];
        }

        if (toml.hooks_file) {
          hooksFiles.push(toml.hooks_file);
        }
      }
    }

    const [localExt, localOptions, localParams]: [
      LocalExt | undefined,
      ExtOptions,
      LocalParams,
    ] = await args.denops.dispatcher.getExt(
      "local",
    ) as [LocalExt | undefined, ExtOptions, LocalParams];
    if (localExt) {
      const action = localExt.actions.local;

      const localPlugins = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: localOptions,
        extParams: localParams,
        actionParams: {
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
            "ddt-*",
            "ddu-*",
            "dpp-*",
            "skkeleton",
          ],
        },
      });

      for (const plugin of localPlugins) {
        if (plugin.name in recordPlugins) {
          recordPlugins[plugin.name] = {
            ...recordPlugins[plugin.name],
            ...plugin,
          };
        } else {
          recordPlugins[plugin.name] = plugin;
        }
      }
    }

    const [packspecExt, packspecOptions, packspecParams]: [
      PackspecExt | undefined,
      ExtOptions,
      PackspecParams,
    ] = await args.denops.dispatcher.getExt(
      "packspec",
    ) as [PackspecExt | undefined, ExtOptions, PackspecParams];
    if (packspecExt) {
      const action = packspecExt.actions.load;

      const packSpecPlugins = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: packspecOptions,
        extParams: packspecParams,
        actionParams: {
          basePath: args.basePath,
          plugins: Object.values(recordPlugins),
        },
      });

      for (const plugin of packSpecPlugins) {
        if (plugin.name in recordPlugins) {
          recordPlugins[plugin.name] = {
            ...recordPlugins[plugin.name],
            ...plugin,
          };
        } else {
          recordPlugins[plugin.name] = plugin;
        }
      }
      //console.log(packSpecPlugins);
    }

    const [lazyExt, lazyOptions, lazyParams]: [
      LazyExt | undefined,
      ExtOptions,
      LazyParams,
    ] = await args.denops.dispatcher.getExt(
      "lazy",
    ) as [LazyExt | undefined, ExtOptions, LazyParams];
    let lazyResult: LazyMakeStateResult | undefined = undefined;
    if (lazyExt) {
      const action = lazyExt.actions.makeState;

      lazyResult = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: lazyOptions,
        extParams: lazyParams,
        actionParams: {
          plugins: Object.values(recordPlugins),
        },
      });
    }

    const checkFiles = [];
    for await (const file of expandGlob(`${Deno.env.get("BASE_DIR")}/*`)) {
      checkFiles.push(file.path);
    }

    const groups = {
      ddc: {
        on_source: "ddc.vim",
      },
      ddu: {
        on_source: "ddu.vim",
      },
    };

    return {
      checkFiles,
      ftplugins,
      hooksFiles,
      multipleHooks,
      groups,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
