import 'package:flutter/material.dart';
import 'package:resources/styles/text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سياسة الخصوصية'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('سياسة الخصوصية لتطبيق القرآن', style: kHeading6),
            const SizedBox(height: 16),
            _buildSection(
              '1. جمع البيانات',
              'نحن لا نجمع أي بيانات شخصية مباشرة. جميع بيانات تقدمك في القراءة والإعدادات تُحفظ محليًا على جهازك باستخدام Hive.',
            ),
            _buildSection(
              '2. الذكاء الاصطناعي (Gemini)',
              'عند استخدام ميزات الذكاء الاصطناعي، يتم إرسال النص المدخل (مثل سؤالك أو الكلمة المراد تفسيرها) إلى Google Gemini API لمعالجته. لا يتم إرسال أي معلومات تعريفية أخرى.',
            ),
            _buildSection(
              '3. التنبيهات',
              'يستخدم التطبيق نظام التنبيهات المحلي لتذكيرك بالورد اليومي. لا تتطلب هذه الميزة اتصالاً بالإنترنت لإرسال الإشعارات.',
            ),
            _buildSection(
              '4. التغييرات',
              'قد نقوم بتحديث سياسة الخصوصية من وقت لآخر. سيتم إخطارك بأي تغييرات جوهرية عبر التطبيق.',
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'آخر تحديث: يناير 2024',
                style: kSubtitle.copyWith(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: kSubtitle.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content, style: kSubtitle.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}
