import 'package:dotto/domain/syllabus.dart';
import 'package:flutter/material.dart';

final class SubjectDetailSyllabusScreen extends StatelessWidget {
  const SubjectDetailSyllabusScreen({required this.syllabus, super.key});

  final Syllabus syllabus;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('概要', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.summary),
          const Divider(height: 0),
          Text('到達目標', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.learningOutcomes),
          const Divider(height: 0),
          Text('提出課題等', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.assignments),
          const Divider(height: 0),
          Text('評価方法・基準', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.evaluationMethod),
          const Divider(height: 0),
          Text('テキスト', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.textbooks),
          const Divider(height: 0),
          Text('参考書', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.referenceBooks),
          const Divider(height: 0),
          Text('履修条件', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.prerequisites),
          const Divider(height: 0),
          Text('事前学習', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.preLearning),
          const Divider(height: 0),
          Text('事後学習', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.postLearning),
          const Divider(height: 0),
          Text('履修上の留意点', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.notes),
          const Divider(height: 0),
          Text('キーワード', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.keywords),
          const Divider(height: 0),
          Text('対象コース・領域', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.targetCourses),
          const Divider(height: 0),
          Text('対象領域', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.targetAreas),
          const Divider(height: 0),
          Text('科目群・科目区分', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.classifications),
          const Divider(height: 0),
          Text('教授言語', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.teachingLanguage),
          const Divider(height: 0),
          Text('授業内容とスケジュール', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.contentsAndSchedule),
          const Divider(height: 0),
          Text('授業・試験の形式', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.teachingAndExamForm),
          const Divider(height: 0),
          Text('DSOP対象科目', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.dsopSubject),
        ],
      ),
    );
  }
}
