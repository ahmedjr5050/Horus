import 'package:apps/core/helper/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'manage/cubit/cubit/detectimages_cubit.dart';


class ImagePickerDemo extends StatefulWidget {
  const ImagePickerDemo({super.key});

  @override
  _ImagePickerDemoState createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _image = image;
          file = File(image.path);
        });
        convertImageToBase64AndSend(file!);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void convertImageToBase64AndSend(File image) async {
    final bytes = await image.readAsBytes();
    final base64String = base64Encode(bytes);
    context.read<DetectimagesCubit>().getimagesai(base64String);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey[800],
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
        ],
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Detect Images',
          style: TextStyle(
              color: Colors.grey[800],
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal, // تغيير لون شريط التطبيق
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(
                'lib/core/assets/images/back.jpg'), // مسار صورة الخلفية
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // تعديل نسبة الشفافية
              BlendMode.darken, // تغيير نوع الدمج إذا لزم الأمر
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_image != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // تغيير لون خلفية الصورة
                      border: Border.all(color: Colors.teal, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(_image!.path),
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'No image selected',
                      style: TextStyle(color: Colors.teal, fontSize: 18),
                    ),
                  ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Pick Image from Gallery'),
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.teal,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // لون النص
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo with Camera'),
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.teal,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // لون النص
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<DetectimagesCubit, DetectimagesState>(
                  builder: (context, state) {
                    if (state is DetectimagesLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is DetectimagesLoaded) {
                      double score = double.parse(state.aiModels.score);
                      if (score < 0.15) {
                        print('Processed Data: ${state.aiModels.score}');
                        return Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Processed Data: Unknown',
                            style: TextStyle(color: Colors.teal, fontSize: 18),
                          ),
                        );
                      } else {
                        print('Processed Data: ${state.aiModels.score}');
                        return Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Processed Data: ${state.aiModels.name}',
                            style: const TextStyle(
                                color: Colors.teal, fontSize: 18),
                          ),
                        );
                      }
                    } else if (state is DetectimagesError) {
                      return Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Error: ${state.error}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
