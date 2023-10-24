import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
  Ddu,
} from "https://deno.land/x/ddu_vim@v3.6.0/types.ts";
import { Denops, fn } from "https://deno.land/x/ddu_vim@v3.6.0/deps.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.6.0/base/config.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.7.1/file.ts";
import { Params as FfParams } from "https://deno.land/x/ddu_ui_ff@v1.1.0/ff.ts";
import { Params as FilerParams } from "https://deno.land/x/ddu_ui_filer@v1.1.0/filer.ts";

type Params = Record<string, unknown>;

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.setAlias("source", "file_rg", "file_external");
    args.setAlias("source", "file_git", "file_external");
    args.setAlias("filter", "matcher_ignore_current_buffer", "matcher_ignores");
    args.setAlias("action", "tabopen", "open");

    args.contextBuilder.patchGlobal({
      ui: "ff",
      profile: false,
      uiOptions: {
        ff: {
          actions: {
            kensaku: async (args: {
              denops: Denops;
              ddu: Ddu;
            }) => {
              args.ddu.updateOptions({
                sourceOptions: {
                  _: {
                    matchers: ["matcher_kensaku"],
                  },
                },
              });
              await args.denops.cmd("echomsg 'change to kensaku matcher'");

              return ActionFlags.Persist;
            },
          },
        },
        filer: {
          toggle: true,
        },
      },
      uiParams: {
        ff: {
          autoAction: {
            name: "preview",
          },
          filterSplitDirection: "floating",
          floatingBorder: "none",
          highlights: {
            filterText: "Statement",
            floating: "Normal",
            floatingBorder: "Special",
          },
          maxHighlightItems: 50,
          onPreview: async (args: {
            denops: Denops;
            previewWinId: number;
          }) => {
            await fn.win_execute(args.denops, args.previewWinId, "normal! zt");
          },
          previewFloating: true,
          previewFloatingBorder: "single",
          //previewSplit: "no",
          //startFilter: true,
          updateTime: 0,
          winWidth: 100,
        } as Partial<FfParams>,
        filer: {
          previewFloating: true,
          sort: "filename",
          sortTreesFirst: true,
          split: "no",
          toggle: true,
        } as Partial<FilerParams>,
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_substring"],
          smartCase: true,
        },
        file_old: {
          matchers: [
            "matcher_relative",
            "matcher_substring",
          ],
          converters: ["converter_hl_dir"],
        },
        file_git: {
          matchers: [
            "matcher_relative",
            "matcher_substring",
          ],
          converters: ["converter_hl_dir"],
        },
        file_rec: {
          matchers: [
            "matcher_substring",
            "matcher_hidden",
          ],
          converters: ["converter_hl_dir"],
        },
        file: {
          matchers: [
            "matcher_substring",
            "matcher_hidden",
          ],
          sorters: ["sorter_alpha"],
          converters: ["converter_hl_dir"],
        },
        dpp: {
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
          sorters: ["sorter_alpha"],
        },
      },
      sourceParams: {
        file_git: {
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
        converter_hl_dir: {
          hlGroup: ["Directory", "Keyword"],
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
        url: {
          defaultAction: "browse",
        },
      },
      kindParams: {},
      actionOptions: {
        narrow: {
          quit: false,
        },
        tabopen: {
          quit: false,
        },
      },
    });

    return Promise.resolve();
  }
}
