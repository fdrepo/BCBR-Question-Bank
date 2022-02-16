import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../repos/auth/phone_auth_repo.dart';
import '../state/app_state.dart';
import '../tags/tags_screen.dart';
import 'auth_actions.dart';
import 'auth_selector.dart';

class OtpScreen extends HookWidget {
  const OtpScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  final String phoneNumber;

  static MaterialPageRoute<void> route(String phoneNumber) {
    return MaterialPageRoute<void>(builder: (_) {
      return OtpScreen(phoneNumber: phoneNumber);
    });
  }

  void _verifyPhone(Store<AppState> store) {
    store.dispatch(AuthAction.sendOtp(phoneNumber));
  }

  void _useOtp(BuildContext context, String smsCode) {
    StoreProvider.of<AppState>(context, listen: false)
        .dispatch(AuthAction.verifyPhoneNumber(smsCode));
  }

  void Function()? _setupAuthenticatedStream(BuildContext context) {
    final store = StoreProvider.of<AppState>(context, listen: false);
    return authenticatedStreamSelected(store.onChange).listen((_) {
      Navigator.of(context).pushAndRemoveUntil(
        TagsScreen.route(),
        (_) => false,
      );
    }).cancel;
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      return _setupAuthenticatedStream(context);
    }, ['navigate-to-tags-when-authenticated']);

    final textEditingController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StoreConnector<AppState, AuthStatus?>(
            onInit: _verifyPhone,
            converter: (store) => authStatusSelector(store.state),
            builder: (context, status) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('OTP'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: status == AuthStatus.signingIn
                        ? null
                        : () => _useOtp(context, textEditingController.text),
                    child: const Text('Verify'),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 38),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
