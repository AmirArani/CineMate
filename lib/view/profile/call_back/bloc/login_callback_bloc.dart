import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_callback_event.dart';
part 'login_callback_state.dart';

class LoginCallbackBloc extends Bloc<LoginCallbackEvent, LoginCallbackState> {
  LoginCallbackBloc() : super(LoginCallbackInitial()) {
    on<LoginCallBackChangeEvent>((event, emit) {
      if (event.success == null) {
        emit(LoginCallbackInitial());
      } else if (event.success!) {
        emit(LoginCallbackSuccess());
      } else {
        emit(LoginCallbackFailed());
      }
    });
  }
}
