import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_management_system/public/utils/font_style.dart';
import '../utils/constant.dart';

// FIX: Removed rounded_loading_button package entirely
// Replaced with a simple ElevatedButton with loading state

class Roundedbutton extends StatefulWidget {
  const Roundedbutton({
    Key? key,
    required Function press,
  })  : _press = press,
        super(key: key);

  final Function _press;

  @override
  State<Roundedbutton> createState() => _RoundedbuttonState();
}

class _RoundedbuttonState extends State<Roundedbutton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 330,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: darkGray,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _isLoading
            ? null
            : () async {
                setState(() => _isLoading = true);
                await widget._press.call();
                if (mounted) setState(() => _isLoading = false);
              },
        child: _isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              )
            : Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/icons/google.png'),
                    height: 24,
                    width: 24,
                  ),
                  SizedBox(width: 24.w),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Log In with Google',
                      style: sfRegularStyle(fontSize: 24.sp, color: darkGray),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}