# Zombie Game

A more involved example, where you run away from zombies.

## Before you begin

Love2D is required to run this demo. There are two ways to run it:

### 1. Drag and Drop

You can drag and drop a zip file into the executable. It will look for main.lua and run it.

Do go this route, there are three things you need to do first:

1. Copy entity.lua, the components folder and the util folder to example/love2d
2. Change the imports in main.lua (they are commented for your convenience)
3. Zip the love2d folder (not examples!).

The directory should look like this:

```
example/
  love2d/
    love2d.md
    main.lua
    entity.lua
    components/
      tree.lua
    util/
      vector.lua
      class.lua
```

And after zipping, you should have a `love2d.zip` file, ready to drop!

### 2. Command line

If you installed Love2D in your PATH, you can run this example with no changes from the command line.

From the root project folder, do:

```shell
> love examples/love2d 
```