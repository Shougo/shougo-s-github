import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
} from "https://deno.land/x/ddu_vim@v3.0.2/types.ts";
import { Denops, fn } from "https://deno.land/x/ddu_vim@v3.0.2/deps.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.0.2/base/config.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.5.0/file.ts";

type Params = Record<string, unknown>;

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.setAlias("source", "file_rg", "file_external");
    args.setAlias("action", "tabopen", "open");

    args.contextBuilder.patchGlobal({
      ui: "ff",
      uiOptions: {
        filer: {
          toggle: true,
        },
      },
      uiParams: {
        ff: {
          filterFloatingPosition: "top",
          filterSplitDirection: "floating",
          floatingBorder: "none",
          highlights: {
            floating: "Normal",
            floatingBorder: "Special",
          },
          onPreview: async (args: {
            denops: Denops;
            previewWinId: number;
          }) => {
            await fn.win_execute(args.denops, args.previewWinId, "normal! zt");
          },
          previewFloating: true,
          previewFloatingBorder: "single",
          previewSplit: "no",
          updateTime: 0,
          winWidth: 100,
        },
        filer: {
          sort: "filename",
          sortTreesFirst: true,
          split: "no",
          toggle: true,
        },
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_substring"],
        },
        file_old: {
          matchers: [
            "matcher_substring",
            "matcher_relative",
            "matcher_ignore_current_buffer",
          ],
        },
        file_external: {
          matchers: [
            "matcher_substring",
          ],
        },
        file_rec: {
          matchers: [
            "matcher_substring",
            "matcher_hidden",
          ],
        },
        file: {
          matchers: [
            "matcher_substring",
            "matcher_hidden",
          ],
          sorters: ["sorter_alpha"],
        },
        dein: {
          defaultAction: "cd",
        },
        markdown: {
          sorters: [],
        },
        line: {
          matchers: [
            "matcher_kensaku",
          ],
        },
        path_history: {
          defaultAction: "uiCd",
        },
        rg: {
          matchers: [
            "matcher_substring",
            "matcher_files",
          ],
        },
      },
      sourceParams: {
        file_external: {
          cmd: ["git", "ls-files", "-co", "--exclude-standard"],
        },
        rg: {
          args: [
            "--ignore-case",
            "--column",
            "--no-heading",
            "--color",
            "never",
          ],
        },
        file_rg: {
          cmd: [
            "rg",
            "--files",
            "--glob",
            "!.git",
            "--color",
            "never",
            "--no-messages",
          ],
          updateItems: 50000,
        },
      },
      filterParams: {
        matcher_kensaku: {
          highlightMatched: "Search",
        },
        matcher_substring: {
          highlightMatched: "Search",
        },
        matcher_ignore_files: {
          ignoreGlobs: ["test_*.vim"],
          ignorePatterns: [],
        },
      },
      kindOptions: {
        file: {
          defaultAction: "open",
          actions: {
            grep: async (args: ActionArguments<Params>) => {
              const action = args.items[0]?.action as ActionData;

              await args.denops.call("ddu#start", {
                name: args.options.name,
                push: true,
                sources: [
                  {
                    name: "rg",
                    params: {
                      path: action.path,
                      input: await fn.input(args.denops, "Pattern: "),
                    },
                  },
                ],
              });

              return Promise.resolve(ActionFlags.None);
            },
            uiCd: async (args: ActionArguments<Params>) => {
              const action = args.items[0]?.action as ActionData;

              await args.denops.call("ddu#ui#do_action", {
                name: "narrow",
                params: {
                  path: action.path,
                },
              });

              return Promise.resolve(ActionFlags.None);
            },
          },
        },
        word: {
          defaultAction: "append",
        },
        deol: {
          defaultAction: "switch",
        },
        action: {
          defaultAction: "do",
        },
        readme_viewer: {
          defaultAction: "open",
        },
      },
      kindParams: {
        action: {
          quit: true,
        },
      },
      actionOptions: {
        narrow: {
          quit: false,
        },
        tabopen: {
          quit: false,
        },
      },
    });

    args.contextBuilder.patchLocal("files", {
      uiParams: {
        ff: {
          split: "floating",
        },
      },
    });

    return Promise.resolve();
  }
}
