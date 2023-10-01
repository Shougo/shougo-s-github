import { BaseConfig, ContextBuilder, Dpp, Plugin } from "https://deno.land/x/dpp_vim@v0.0.1/types.ts";
import { Denops } from "https://deno.land/x/dpp_vim@v0.0.1/deps.ts";

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
    args.contextBuilder.setGlobal({
      protocols: ['git'],
    });

    let plugins: Plugin[] = [];

    const [_, options] = await args.contextBuilder.get(args.denops);

    plugins = plugins.concat(
      await args.dpp.extAction(
        args.denops, options, "local", "local", {
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
            "skkeleton",
            "neco-vim",
          ],
        }
      ) as Plugin[],
    );

    plugins = plugins.concat(
      await args.dpp.extAction(
        args.denops, options, "toml", "load", {
          path: "$BASE_DIR/dein.toml",
          options: {
            lazy: true,
          },
        }
      ) as Plugin[],
    );

    const stateLines = await args.dpp.extAction(
      args.denops,
      options,
      "lazy",
      "makeState",
    ) as string[];

    return {
      plugins,
      stateLines,
    };
  }
}
