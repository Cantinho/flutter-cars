abstract class PageState {}

class Loading extends PageState {
  String title;
  String message;

  Loading({this.title, this.message});
}

class Error extends PageState {
  String error;
  String title;
  String message;

  Error({this.error, this.title, this.message});
}

class Success extends PageState {
  String title;
  String message;

  Success({this.title, this.message});
}