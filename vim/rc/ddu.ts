import { BaseConfig } from "https://deno.land/x/ddu_vim@v3.0.1/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.0.1/base/config.ts";

export class Config extends BaseConfig {
  // deno-lint-ignore require-await
  override async config(args: ConfigArguments): Promise<void> {
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
          filterSplitDirection: "floating",
          floatingBorder: "none",
          previewFloating: true,
          previewFloatingBorder: "single",
          previewSplit: "no",
          highlights: {
            floating: "Normal",
            floatingBorder: "Special",
          },
          updateTime: 0,
          winWidth: 100,
        },
        filer: {
          split: "no",
          sort: "filename",
          sortTreesFirst: true,
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
  }
}
