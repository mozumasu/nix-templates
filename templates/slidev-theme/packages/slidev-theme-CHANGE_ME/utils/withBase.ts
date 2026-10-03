// バインド式 (:src) や frontmatter の値は Vite の asset 変換を通らず --base が付かないので、
// public/ のルート絶対パス (/foo.png) にはここで BASE_URL を前置する。
// Slidev の resolveAssetUrl は $asset() で base 付きにした値にも二重に前置するため、
// base で始まる値はそのまま返す (base と同名のディレクトリが public/ にある場合は誤判定する)
// base は node --test から注入できるよう省略可能な引数にしている
export function withBase(path?: string, base = import.meta.env.BASE_URL) {
  if (!path || !path.startsWith('/'))
    return path
  return path.startsWith(base) ? path : base + path.slice(1)
}
