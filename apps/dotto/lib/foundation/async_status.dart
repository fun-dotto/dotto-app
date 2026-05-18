enum AsyncStatus {
  idle, // 初期状態
  loading, // 読み込み中
  success, // 成功
  failure, // 失敗
  refreshing, // 更新中
  retrying, // 再試行中
}
