import { BaseConfig } from "https://deno.land/x/ddc_vim@v5.0.1/types.ts";
import { fn } from "https://deno.land/x/ddc_vim@v5.0.1/deps.ts";
import { ConfigArguments } from "https://deno.land/x/ddc_vim@v5.0.1/base/config.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const hasNvim = args.denops.meta.host === "nvim";
    const hasWindows = await fn.has(args.denops, "win32");

    const commonSources = [
      "around",
      "file",
    ];

    const mocWord = Deno.env.get("MOCWORD_DATA") ? ["mocword"] : [];

    args.contextBuilder.patchGlobal({
      ui: "pum",
      autoCompleteEvents: [
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "CmdlineEnter",
        "CmdlineChanged",
        "TextChangedT",
      ],
      sources: commonSources,
      cmdlineSources: {
        ":": ["cmdline", "cmdline-history", "around"],
        "@": ["input", "cmdline-history", "file", "around"],
        ">": ["input", "cmdline-history", "file", "around"],
        "/": ["around", "line"],
        "?": ["around", "line"],
        "-": ["around", "line"],
        "=": ["input"],
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_head", "matcher_prefix", "matcher_length"],
          sorters: ["sorter_rank"],
          //converters: ["converter_remove_overlap"],
          timeout: 1000,
        },
        around: {
          mark: "A",
        },
        buffer: {
          mark: "B",
        },
        vim: {
          mark: "vim",
          isVolatile: true,
        },
        cmdline: {
          mark: "cmdline",
          forceCompletionPattern: "\\S/\\S*|\\.\\w*",
        },
        copilot: {
          mark: "cop",
          matchers: [],
          minAutoCompleteLength: 0,
          isVolatile: false,
        },
        codeium: {
          mark: "cod",
          matchers: ["matcher_length"],
          minAutoCompleteLength: 0,
          isVolatile: true,
        },
        input: {
          mark: "input",
          forceCompletionPattern: "\\S/\\S*",
          isVolatile: true,
        },
        line: {
          mark: "line",
        },
        mocword: {
          mark: "mocword",
          minAutoCompleteLength: 4,
          isVolatile: true,
        },
        lsp: {
          mark: "lsp",
          forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
          dup: "force",
        },
        rtags: {
          mark: "R",
          forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
        },
        file: {
          mark: "F",
          isVolatile: true,
          minAutoCompleteLength: 1000,
          forceCompletionPattern: "\\S/\\S*",
        },
        "cmdline-history": {
          mark: "history",
          sorters: [],
        },
        "shell-history": {
          mark: "history",
        },
        shell: {
          mark: "sh",
          isVolatile: true,
          forceCompletionPattern: "\\S/\\S*",
        },
        "shell-native": {
          mark: "sh",
          isVolatile: true,
          forceCompletionPattern: "\\S/\\S*",
        },
        rg: {
          mark: "rg",
          minAutoCompleteLength: 5,
          enabledIf: "finddir('.git', ';') != ''",
        },
        skkeleton: {
          mark: "skk",
          matchers: ["skkeleton"],
          sorters: [],
          minAutoCompleteLength: 2,
          isVolatile: true,
        },
        yank: {
          mark: "Y",
        },
      },
      sourceParams: {
        buffer: {
          requireSameFiletype: false,
          limitBytes: 50000,
          fromAltBuf: true,
          forceCollect: true,
        },
        file: {
          filenameChars: "[:keyword:].",
        },
        lsp: {
          enableDisplayDetail: true,
        },
        "shell-native": {
          shell: "fish",
        },
      },
      postFilters: ["sorter_head"],
    });

    for (
      const filetype of [
        "markdown",
        "markdown_inline",
        "gitcommit",
        "comment",
      ]
    ) {
      args.contextBuilder.patchFiletype(filetype, {
        sources: commonSources.concat(["line"]).concat(mocWord),
      });
    }

    for (const filetype of ["html", "css"]) {
      args.contextBuilder.patchFiletype(filetype, {
        sourceOptions: {
          _: {
            keywordPattern: "[0-9a-zA-Z_:#-]*",
          },
        },
      });
    }

    for (const filetype of ["zsh", "sh", "bash"]) {
      args.contextBuilder.patchFiletype(filetype, {
        sourceOptions: {
          _: {
            keywordPattern: "[0-9a-zA-Z_./#:-]*",
          },
        },
        sources: [
          hasWindows ? "shell" : "shell-native",
          "around",
        ],
      });
    }
    args.contextBuilder.patchFiletype("deol", {
      specialBufferCompletion: true,
      sources: [
        hasWindows ? "shell" : "shell-native",
        "shell-history",
        "around",
      ],
      sourceOptions: {
        _: {
          keywordPattern: "[0-9a-zA-Z_./#:-]*",
        },
      },
    });

    // Use "#" as TypeScript keywordPattern
    for (const filetype of ["typescript"]) {
      args.contextBuilder.patchFiletype(filetype, {
        sourceOptions: {
          _: {
            keywordPattern: "#?[a-zA-Z_][0-9a-zA-Z_]*",
          },
        },
      });
    }

    if (hasNvim) {
      for (
        const filetype of [
          "css",
          "go",
          "html",
          "lua",
          "python",
          "ruby",
          "typescript",
          "typescriptreact",
          "tsx",
          "graphql",
        ]
      ) {
        args.contextBuilder.patchFiletype(filetype, {
          sources: ["lsp"].concat(commonSources),
        });
      }
    }

    args.contextBuilder.patchFiletype("vim", {
      // Enable specialBufferCompletion for cmdwin.
      specialBufferCompletion: true,
      sources: ["lsp", "vim"].concat(commonSources),
    });
  }
}
