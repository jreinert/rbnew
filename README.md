# Rbnew

Rbnew is a tiny vim plugin that helps with creating new files in ruby projects.

## Usage

```
:Rbnew class MyProject::Services::SomeService
```

Rbnew will prompt for a root directory (it will suggest `app` or `lib` if
they are available, in that order of preference)

It will then create the necessary directories and open the following file

```
{entered root directory}/my_project/services/some_service.rb
```

A skeleton for that class/module will be inserted into the buffer and
the cursor will be placed inside it in insert mode.
