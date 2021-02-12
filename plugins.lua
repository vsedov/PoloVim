local iron = require('iron')

iron.core.add_repl_definitions {
  python = {
    mycustom = {
      command = {"mycmd"}
    }
  },
  clojure = {
    lein_connect = {
      command = {"lein", "repl", ":connect"}
    }
  }
}

iron.core.set_config {
  preferred = {
    python = "ipython",
    clojure = "lein"
  }
}
