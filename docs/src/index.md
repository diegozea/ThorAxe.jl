```@eval
import ThorAxe
using Markdown
Markdown.parse(read(joinpath(pkgdir(ThorAxe), "README.md"), String))
```
