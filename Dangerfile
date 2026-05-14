# Dangerfile for Flutter project

# Bot PRの判定
is_bot_pr = github.pr_json["user"]["login"].include?("[bot]")

# PRの基本情報確認
has_app_changes = !git.modified_files.grep(/^lib\//).empty?
has_test_changes = !git.modified_files.grep(/^test\//).empty?

unless is_bot_pr
  # PRタイトルのチェック
  if github.pr_title.length < 5
    fail("PRタイトルが短すぎます。より詳細なタイトルを入力してください。")
  end

  # PR説明のチェック
  if github.pr_body.length < 10
    warn("PR説明が短すぎます。変更内容をより詳しく記載することをお勧めします。")
  end

  if github.pr_json["requested_reviewers"].nil? || github.pr_json["requested_reviewers"].empty?
    fail("PRにReviewerが設定されていません。Reviewerを設定してください。")
  end

  # Assigneesのチェック
  if github.pr_json["assignees"].nil? || github.pr_json["assignees"].empty?
    fail("PRにAssigneeが設定されていません。あなた自身をアサインしてください。")
  end

  # Milestoneのチェック
  if github.pr_json["milestone"].nil?
    fail("PRにMilestoneが設定されていません。適切なMilestoneを設定してください。")
  end
end

# 大きなPRの警告
if git.lines_of_code > 500
  warn("このPRは大きすぎます (#{git.lines_of_code} lines)。小さなPRに分割することを検討してください。")
end

# アプリコードが変更されたのにテストが追加されていない場合の警告
if has_app_changes && !has_test_changes
  warn("アプリコードが変更されていますが、テストが追加されていません。テストの追加を検討してください。")
end

# 重要なファイルの変更確認
important_files = [
  "pubspec.yaml",
  "android/app/build.gradle",
  "ios/Runner/Info.plist",
  "lib/main.dart"
]

modified_important_files = git.modified_files.select { |file| important_files.include?(file) }
if !modified_important_files.empty?
  warn("重要なファイルが変更されています: #{modified_important_files.join(', ')}")
end

# 削除されたファイルの確認
if !git.deleted_files.empty?
  message("削除されたファイル: #{git.deleted_files.join(', ')}")
end

# 新しいファイルの確認
if !git.added_files.empty?
  message("追加されたファイル: #{git.added_files.join(', ')}")
end

# pubspec.yamlの変更がある場合のリマインダー
if git.modified_files.include?("pubspec.yaml")
  message("pubspec.yamlが変更されています。`task install`を実行してください。")
end

# コードの品質チェック（パスが存在する場合のみ）
if File.exist?("reports/lint-results.xml")
  checkstyle_format.base_path = Dir.pwd
  checkstyle_format.report 'reports/lint-results.xml'
end

# 成功メッセージ
message("Dangerのチェックが完了しました! 🎉")
