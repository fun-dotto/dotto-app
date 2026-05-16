# Dotto

[![Test Flutter App](https://github.com/fun-dotto/dotto-app/actions/workflows/test-flutter-app.yaml/badge.svg)](https://github.com/fun-dotto/dotto-app/actions/workflows/test-flutter-app.yaml)

## ようこそ、Dotto 開発チームへ！

[Dotto Wiki](https://www.notion.so/fun-dotto/30428560ac7980778136e29902746cae?v=30428560ac79801a92ef000c7ca1f6a3&source=copy_link)

## セットアップ

### 事前にやっておくこと

- macOSを最新バージョンにアップデート
- [Homebrewをインストール](https://www.notion.so/fun-dotto/30428560ac79801095f2e00033d9a132)
- [最新バージョンのXcodeをインストール](https://www.notion.so/fun-dotto/30428560ac79807797c3d6f62d1d393d)
- [miseをインストール](https://www.notion.so/fun-dotto/30428560ac79804caaf8ed3a3ad30cb5)

### リポジトリをクローン

```zsh
git clone git@github.com:fun-dotto/app.git dotto-app
cd dotto-app
```

### ツールをインストール

```zsh
mise install
```

### pre-commitをセットアップ

```
mise generate git-pre-commit --write --task=pre-commit
```

### Dart

```zsh
echo 'export PATH="$HOME/.pub-cache/bin:$PATH"' >> ~/.zshrc
export PATH="$HOME/.pub-cache/bin:$PATH"
```

### Google Cloud & Firebase を認証

```zsh
gcloud auth login
firebase login
```

### 色々セットアップ

```zsh
mise setup
```

### ビルドして起動する

```zsh
mise run app
```

&copy; 2026 Dotto
