local Runner = require "nvim-test.runner"

local pytest = Runner:init({
  command = { "docker-compose" },
  args = { "exec", "web", "python", "manage.py", "test", "--parallel", "--no-input" },
  file_pattern = "\\v(test_[^.]+|[^.]+_test|tests)\\.py$",
  find_files = { "test_{name}.py", "{name}_test.py", "tests.py" },
}, {
  python = [[
      ; Class
      (
        (
          class_definition name: (identifier) @test-name
          (#match? @test-name "[Tt]est")
        )
      @scope-root)

      ; Function
      (
        (
          function_definition name: (identifier) @test-name
          (#match? @test-name "^[Tt]est")
        )
      @scope-root)
    ]],
})

function pytest:build_args(args, filename, opts)
  if filename then
    local path, _ = vim.fn.fnamemodify(filename, ":.:r"):gsub("/", ".")
    table.insert(args, path)
  end
  if opts.tests and #opts.tests > 0 then
    args[#args] = args[#args] .. "." .. table.concat(opts.tests, ".")
  end
end

return pytest
