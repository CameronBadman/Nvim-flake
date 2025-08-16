{
  plugins.lsp.servers.jdtls = {
    enable = true;

    # Configuration for Maven projects
    configuration = {
      # Use system-wide JDK
      runtimes = [
        {
          name = "JavaSE-11";
          path = "/usr/lib/jvm/java-11-openjdk/"; # Adjust path as needed
        }
        {
          name = "JavaSE-17";
          path = "/usr/lib/jvm/java-17-openjdk/"; # Adjust path as needed
        }
      ];
    };

    settings = {
      java = {
        # Enable Maven support
        maven = {
          downloadSources = true;
          updateSnapshots = false;
        };

        # Configure completion
        completion = {
          favoriteStaticMembers = [
            "org.hamcrest.MatcherAssert.assertThat"
            "org.hamcrest.Matchers.*"
            "org.hamcrest.CoreMatchers.*"
            "org.junit.jupiter.api.Assertions.*"
            "java.util.Objects.requireNonNull"
            "java.util.Objects.requireNonNullElse"
            "org.mockito.Mockito.*"
          ];
          filteredTypes = [
            "com.sun.*"
            "io.micrometer.shaded.*"
            "java.awt.*"
            "jdk.*"
            "sun.*"
          ];
          importOrder = [
            "java"
            "javax"
            "com"
            "org"
          ];
        };

        # Enable automatic organization of imports
        saveActions = {
          organizeImports = true;
        };

        # Configure sources and Javadoc
        sources = {
          organizeImports = {
            starThreshold = 99;
            staticStarThreshold = 99;
          };
        };

        # Import gradle projects automatically
        import = {
          gradle = {
            enabled = true;
          };
          maven = {
            enabled = true;
          };
          exclusions = [
            "**/node_modules/**"
            "**/.metadata/**"
            "**/archetype-resources/**"
            "**/META-INF/maven/**"
          ];
        };

        # Project configuration
        project = {
          referencedLibraries = [
            "lib/**/*.jar"
            "**/lib/**/*.jar"
          ];
        };

        # Enable semantic highlighting
        semanticHighlighting = {
          enabled = true;
        };

        # Configure formatting (Google Java Format style)
        format = {
          enabled = true;
          settings = {
            url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml";
            profile = "GoogleStyle";
          };
        };

        # Enable code lens
        referencesCodeLens = {
          enabled = true;
        };
        implementationsCodeLens = {
          enabled = true;
        };

        # Configure signature help
        signatureHelp = {
          enabled = true;
          description = {
            enabled = true;
          };
        };

        # Content assist settings
        contentProvider = {
          preferred = "fernflower";
        };

        # Eclipse settings
        eclipse = {
          downloadSources = true;
        };

        # Configure workspace
        workspace = {
          filteredTypes = [
            "com.sun.*"
            "io.micrometer.shaded.*"
            "java.awt.*"
            "jdk.*"
            "sun.*"
          ];
        };
      };
    };

    # Custom initialization options for better Maven support
    initOptions = {
      bundles = [ ];
      workspaceFolders = null;
      settings = {
        java = {
          autobuild = {
            enabled = false;
          };
          maxConcurrentBuilds = 1;
        };
      };
    };

    # Custom command for jdtls with Maven support
    cmd = [
      "jdtls"
      "--jvm-arg=-Declipse.application=org.eclipse.jdt.ls.core.id1"
      "--jvm-arg=-Dosgi.bundles.defaultStartLevel=4"
      "--jvm-arg=-Declipse.product=org.eclipse.jdt.ls.core.product"
      "--jvm-arg=-Xmx4G"
      "--jvm-arg=--add-modules=ALL-SYSTEM"
      "--jvm-arg=--add-opens"
      "--jvm-arg=java.base/java.util=ALL-UNNAMED"
      "--jvm-arg=--add-opens"
      "--jvm-arg=java.base/java.lang=ALL-UNNAMED"
    ];
  };
}
