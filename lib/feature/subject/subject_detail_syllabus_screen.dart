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
          Text('到達目標', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.learningOutcomes),
          Text('提出課題等', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.assignments),
          Text('評価方法・基準', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.evaluationMethod),
          Text('テキスト', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.textbooks),
          Text('参考書', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.referenceBooks),
          Text('履修条件', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.prerequisites),
          Text('事前学習', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.preLearning),
          Text('事後学習', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.postLearning),
          Text('履修上の留意点', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.notes),
          Text('キーワード', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.keywords),
          Text('対象コース・領域', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.targetCourses),
          Text('対象領域', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.targetAreas),
          Text('科目群・科目区分', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.classifications),
          Text('教授言語', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.teachingLanguage),
          Text('授業内容とスケジュール', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.contentsAndSchedule),
          Text('授業・試験の形式', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.teachingAndExamForm),
          Text('DSOP対象科目', style: Theme.of(context).textTheme.titleMedium),
          Text(syllabus.dsopSubject),
        ],
      ),
    );
  }
}
