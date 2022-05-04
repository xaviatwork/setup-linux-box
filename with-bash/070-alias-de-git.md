# Configurar alias de Git

Como los comandos de Git se usan tan frecuentemente, se suelen configurar alias que *acortan* los comandos habituales [^gitalias]; también configura una *colorida* versión de `git log` (en una sola línea) [^gitlog]:

```bash
#!/usr/bin/env bash

git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.st status

git config --global alias.l1 "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

echo "Git aliases configured!"
```

[^gitalias]: Los alias de Git recomendados en la documentación oficial [2.7 Git Basics - Git Aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases)

[^gitlog]: [A better git log](https://coderwall.com/p/euwpig/a-better-git-log) en coderwall.com.
