/// Class for Environment variables.
///
/// This environment setup was made using this article https://medium.com/@nayanbabariya/set-up-environment-variables-in-flutter-for-secure-and-scalable-apps-7409ae0c383e as a reference
///
/// In order for this class to work you need to add the SERVER_ADDRESS=YOUR_ADDRESS to your .env folder:
///  .env/development.env
/// 
///  .env/staging.env
final class Environment {
  static const serverAddress = String.fromEnvironment('SERVER_ADDRESS');
  static const environment = String.fromEnvironment('ENVIRONMENT');
}