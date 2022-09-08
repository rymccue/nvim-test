local Runner = require "nvim-test.runner"

local pytest = Runner:init({
  command = { "docker-compose exec web python manage.py test" },
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

function pytest:build_test_args(args, tests)
  args[#args] = args[#args] .. "::" .. table.concat(tests, "::")
end

return pytest
