import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:ucourses/core/constants/app_colors.dart';
import 'package:ucourses/core/constants/app_text_styles.dart';
import 'package:ucourses/core/shared/widgets/decorators/diagonal_clipper.dart';
import 'package:ucourses/core/shared/widgets/decorators/gradient_container_widget.dart';
import 'package:ucourses/features/student/presentation/cubit/student_cubit.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../data/data_source/remote/firebase_remote_datasource.dart';

class CertificateScreen extends StatefulWidget {
  final double score;
  final int totalScore;
  final String courseName;
  final String courseId;

  const CertificateScreen({
    super.key,
    required this.score,
    required this.totalScore,
    required this.courseName,
    required this.courseId,
  });

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  Future<void> _generateAndDownloadPDF(String studentName) async {
    final pdf = pw.Document();
    final fontData =
        await rootBundle.load('lib/assets/fonts/Tajawal-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(base: ttf),
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.purple800),
              borderRadius: pw.BorderRadius.circular(20),
            ),
            padding: const pw.EdgeInsets.all(30),
            child: pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Center(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('شهادة إتمام الدورة',
                        style: const pw.TextStyle(fontSize: 18)),
                    pw.SizedBox(height: 20),
                    pw.Text(studentName,
                        style: const pw.TextStyle(fontSize: 18)),
                    pw.SizedBox(height: 10),
                    pw.Text(widget.courseName,
                        style: pw.TextStyle(font: ttf, fontSize: 18)),
                    pw.SizedBox(height: 10),
                    pw.Text('تهانينا على إتمام الدورة!',
                        style: const pw.TextStyle(fontSize: 18)),
                    pw.SizedBox(height: 10),
                    pw.Text('الدرجة: ${widget.score}',
                        style: const pw.TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    final bytes = await pdf.save();
    await Printing.sharePdf(
        bytes: bytes, filename: 'certificate-$studentName.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, StudentState>(
      builder: (context, state) {
        if (state is StudentLoggedIn) {
          String currentStudentName = state.student.username;
          bool isPassing = widget.score >= (widget.totalScore / 2);
          String message =
              isPassing ? 'تهانينا!' : 'للأسف لم تنجح، حاول مرة أخرى!';
          String lottieAnimation = isPassing
              ? 'lib/assets/jsons/animation/certificate.json'
              : 'lib/assets/jsons/animation/error.json';

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(backgroundColor: Colors.transparent),
            body: Stack(
              children: [
                ClipPath(
                  clipper: DiagonalClipper(),
                  child: const GradientContainer(
                      firstGradientColor: AppColors.thirdColor,
                      secondGradientColor: AppColors.fourthColor),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 10))
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Lottie.asset(lottieAnimation,
                                    height: 100, width: 100, repeat: false),
                                const SizedBox(height: 10),
                                Text(currentStudentName, style: Styles.style18),
                                const SizedBox(height: 10),
                                if (isPassing)
                                  Text(
                                      "تم بنجاح إتمام دورة : ${widget.courseName}",
                                      style: const TextStyle(fontSize: 16)),
                                Text(message,
                                    textAlign: TextAlign.center,
                                    style: Styles.style15grey),
                                const SizedBox(height: 20),
                                const Divider(),
                                const Text('درجتك', style: Styles.style16),
                                const SizedBox(height: 10),
                                Text('${widget.score}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: isPassing
                                            ? Colors.green
                                            : Colors.red)),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () async {
                                    final FirebaseRemoteDataSource
                                        remoteDataSource =
                                        FirebaseRemoteDataSource();
                                    try {
                                      await remoteDataSource
                                          .markCourseAsCompleted(
                                              state.student.id,
                                              widget.courseId,
                                              widget.score);
                                      Navigator.of(context)
                                          .pushNamed('/courses');
                                    } catch (e) {
                                      print("An error occurred: $e");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  child:
                                      Text('إنهاء', style: Styles.style16White),
                                ),
                                const SizedBox(height: 15),
                                if (isPassing)
                                  ElevatedButton.icon(
                                    onPressed: () => _generateAndDownloadPDF(
                                        currentStudentName),
                                    icon: const Icon(Icons.download),
                                    label: Text('تحميل الشهادة',
                                        style: Styles.style16White),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.secondaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text("Please log in to view this page.")),
          );
        }
      },
    );
  }
}
