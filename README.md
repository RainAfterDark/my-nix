My nix config. Undergoing a potential rewrite.

This is just to document what I would like to do with this eventually:

- Use dendritic pattern and nix-wrapper-modules (I never really wanted to pull in "framework" dependencies, but these two might just be worth it)
- Style each wrapped package since those will no longer have to depend on stylix modules
- *Potentially* ditch home-manager (very desirable outcome from all this if possible)

An ideal world config for me would be something that's faster to evaluate (and therefore faster to iterate), simpler maintainance, and better opt-in (or opt-out) for modules on the host level (and maybe even user level, if I decide to have multi-user setups).