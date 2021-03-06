import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gotit/enums/dialog_buttons_enum.dart';
import 'package:gotit/enums/dialog_result_enum.dart';
import 'package:gotit/services/validator_service.dart';
import 'package:gotit/views/widgets/alert_dialog.dart';
import 'package:gotit/presenters/user_setting_presenter.dart';
import 'package:gotit/services/state_message_service.dart';
import 'package:gotit/enums/result_message_enum.dart';
import 'package:gotit/helpers.dart';

class UserSecuritySettings extends StatelessWidget {
  final UserSettingsPresenter _securitySetting = UserSettingsPresenter();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void _updateSecurityData(BuildContext context, DialogResult result){
    if(result == DialogResult.update) {
      if(formkey.currentState.validate()) {
        formkey.currentState.save();
        _securitySetting.changePassword(context).then((value) {
          var flag = !_securitySetting.result.isSucceeded || !_securitySetting.result.data;
          var resultMessage = Helpers.getEnumFromString(ResultMessage.values, _securitySetting.result.message);
          DialogBox.show(
              context: context,
              title: Text(flag ? 'Error' : 'Done'),
              content: Text(
                resultMessage != null ? StateMessage.get(resultMessage) : _securitySetting.result.message,
                style: TextStyle(
                    fontSize: 20
                ),  
                textAlign: TextAlign.center
              ),
              dialogButton: DialogButtons.ok
          );
        });
        formkey.currentState.reset();
      }
    } else {
      formkey.currentState.reset();
    }

  }
  @override
  Widget build(BuildContext context) {
    return DialogBox.dialog(
        context: context,
        title: Text('SECURITY'),
        content: Form(
          key: formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    labelText: 'Old password',
                    hintText: 'Enter your password',
                  ),
                  validator: Validator.requiredField,
                  onSaved: _securitySetting.setOldPassword,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      labelText: 'New password',
                      hintText: 'Enter your new password'
                  ),
                  validator: Validator.passwordField,
                  onSaved: _securitySetting.setNewPassword,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      labelText: 'Repeate new password',
                      hintText: 'Repeate your new password'
                  ),
                  validator: Validator.rePasswordField,
                  onSaved: _securitySetting.setRepeatPassword,
                ),
              )
            ],
          ),
        ),
        dialogButton: DialogButtons.update_cancle,
        onPress: (DialogResult result) => _updateSecurityData(context, result)
    );
  }

}