local ls = require("luasnip")
local parse = ls.parser.parse_snippet
-- local s = ls.snippet
-- local t = ls.text_node
-- local i = ls.insert_node
-- local d = ls.dynamic_node
-- local sn = ls.snippet_node
-- local c = ls.choice_node

local dependencies = [[
[tool.poetry.dependencies]
python = "^3.10.4"
rich = "^"
requests = "^"
icecream = "^"
python-dotenv = "^"

]]

local dev_dependencies = [[
[tool.poetry.dev-dependencies]
interrogate = "^1.5.0"
isort = "^5.10.1"
vulture = "^2.3"
coverage = "^6.3.2"
yapf = "^0.32.0"
debugpy = "^1.6.0"
flake8 = "^4.0.1"
flake8-annotations = "^2.8.0"
flake8-bugbear = "^22.3.23"
flake8-string-format = "^0.3.0"
flake8-isort = "^4.1.1"
pep8-naming = "^0.12.1"
pytest = "^7.1.1"
pytest-cov = "^3.0.0"
pytest-xdist = { version = "~=2.3.0", extras = ["psutil"] }
taskipy = "~=1.7.0"
pdoc = "^11.0.0"
#commitizen = "^2.23.0"
pre-commit = "^2.18.1"
]]

local taskipy = [[[tool.taskipy.tasks]
start = "python -m $1"
lint = "pre-commit run --all-files"
precommit = "pre-commit install"
prepare = "pre-commit install && pre-commit install --hook-type commit-msg"
build = "poetry build"
test-nocov = "pytest -n auto"
test = "pytest -n auto --cov-report= --cov --ff"
retest = "pytest -n auto --cov-report= --cov --lf"
html = "coverage html"
report = "coverage report"
doc = "interrogate -c pyproject.toml"
isort = "isort ."
freeze = "poetry export -f requirements.txt > requirements.txt --without-hashes"
]]

local yapf = [[ 
[tool.yapf]
align_closing_bracket_with_visual_indent = "False"
allow_multiline_dictionary_keys = "True"
allow_multiline_lambdas = "False"
allow_split_before_default_or_named_assigns="False"
allow_split_before_dict_value="False"
arithmetic_precedence_indication="True"
blank_lines_around_top_level_definition="2"
# blank_lines_between_top_level_imports_and_variables="2"
blank_line_before_class_docstring="False"
blank_line_before_module_docstring="False"
blank_line_before_nested_class_or_def="True"
coalesce_brackets="True"
column_limit="120"
continuation_align_style="SPACE"
continuation_indent_width="4"
dedent_closing_brackets="False"
disable_ending_comma_heuristic="True"
each_dict_entry_on_separate_line="True"
force_multiline_dict="True"
#i18n_comment="#\\..*"
i18n_function_call="N_, _"
indent_closing_brackets="False"
indent_dictionary_value="True"
indent_width="4"
join_multiple_lines="True"
no_spaces_around_selected_binary_operators="False"
spaces_around_default_or_named_assign="False"
spaces_around_dict_delimiters="False"
spaces_around_list_delimiters="False"
spaces_around_power_operator="False"
spaces_around_subscript_colon="False"
spaces_around_tuple_delimiters="False"
spaces_before_comment="2"
space_between_ending_comma_and_closing_bracket="False"
space_inside_brackets="False"
split_all_comma_separated_values="False"
split_arguments_when_comma_terminated="True"
split_before_bitwise_operator="True"
split_before_closing_bracket="True"
split_before_dict_set_generator="True"
split_before_dot="True"
split_before_expression_after_opening_paren="True"
split_before_first_argument="True"
split_before_logical_operator="True"
split_before_named_assigns="True"
split_complex_comprehension="True"
split_penalty_after_opening_bracket="300"
split_penalty_after_unary_operator="10000"
split_penalty_arithmetic_operator="300"
split_penalty_before_if_expr="0"
split_penalty_bitwise_operator="300"
split_penalty_comprehension="2100"
split_penalty_excess_character="7000"
split_penalty_for_added_line_split="30"
# split_penalty_import_names="0"
split_penalty_logical_operator="300"
use_tabs="False"

]]

local interrogate = [[[tool.interrogate]
ignore-init-method = true
ignore-init-module = false
ignore-magic = true
ignore-semiprivate = false
ignore-private = true
ignore-property-decorators = true
ignore-module = true
fail-under = 100
exclude = ["setup.py", "docs", "build",  "_version.py", "versioneer.py"]
ignore-regex = ["^get$", "^mock_.*", ".*BaseClass.*", "^fit$", "^transform$", "^setup"]
verbose = 1
quiet = false
whitelist-regex = []
color = true

]]

local coverage = [[
[tool.coverage.run]
parallel = true
branch = true
source_pkgs = ["$1"]
source = ["tests"]
omit = ["**/__main__.py"]

[tool.coverage.report]
show_missing = true
fail_under = 70
precision = 2
exclude_lines = ["pragma: no cover", "pass"]

]]

local isort = [[
[tool.isort]
multi_line_output = 6
order_by_type = false
case_sensitive = true
combine_as_imports = true
line_length = 120
atomic = true

]]
local basic_pyproject = dependencies
    .. dev_dependencies
    .. [[
[build-system]
requires = ["poetry-core>=1.0.0"]
build-backend = "poetry.core.masonry.api"

]]
    .. taskipy
    .. yapf
    .. interrogate
    .. coverage
    .. isort

local toml_snippets = {
    parse({ trig = "pyproject" }, basic_pyproject),
    parse({ trig = "isort" }, isort),
    parse({ trig = "yapf" }, yapf),
    parse({ trig = "interrogate" }, interrogate),
    parse({ trig = "coverage" }, coverage),
    parse({ trig = "dependencies" }, dependencies),
    parse({ trig = "dev_dependencies" }, dev_dependencies),
}

return toml_snippets
