class PageState {
  String title;
  String message;

  PageState({this.title, this.message});
}

class Loading extends PageState {
  Loading({title, message}) : super(title: title, message: message);
}

class Error extends PageState {
  String error;
  Error({this.error, title, message}) : super(title: title, message: message);
}

class Success extends PageState {
  Success({title, message}) : super(title: title, message: message);
}