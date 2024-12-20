import 'dart:html';

const namePrint = 'namePrint';
const ipPrint = 'ipPrint';
const numberPagePrint = 'numberPagePrint';
const username = 'username';
const password = 'password';
const token = 'token';

void saveToLocalStorage(String key, String value) {
  window.localStorage[key] = value;
}

String? getFromLocalStorage(String key) {
  return window.localStorage[key];
}

void deleteFromLocalStorage(String key) {
  window.localStorage.remove(key);
}

void clearLocalStorage() {
  window.localStorage.clear();
}

void saveNamePrint(String name) {
  saveToLocalStorage(namePrint, name);
}

String loadNamePrint() {
  return getFromLocalStorage(namePrint) ?? "";
}

void deleteNamePrint() {
  deleteFromLocalStorage(namePrint);
}

void saveIpPrint(String name) {
  saveToLocalStorage(ipPrint, name);
}

String loadIpPrint() {
  return getFromLocalStorage(ipPrint) ?? "";
}

void deleteIpPrint() {
  deleteFromLocalStorage(ipPrint);
}

void saveNumberPagePrint(String name) {
  saveToLocalStorage(numberPagePrint, name);
}

String loadNumberPagePrint() {
  return getFromLocalStorage(numberPagePrint) ?? "1";
}

void deleteNumberPagePrint() {
  deleteFromLocalStorage(numberPagePrint);
}

void saveUsername(String name) {
  saveToLocalStorage(username, name);
}

String loadUsername() {
  return getFromLocalStorage(username)??'';
}

void deleteUsername() {
  deleteFromLocalStorage(username);
}

void savePassword(String pass) {
  saveToLocalStorage(password, pass);
}

String loadPassword() {
  return getFromLocalStorage(password)??'';
}

void deletePassword() {
  deleteFromLocalStorage(password);
}

void clearData() {
  clearLocalStorage();
}

void saveToken(String tokenValue) {
  saveToLocalStorage(token, tokenValue);
}

String loadToken() {
  return getFromLocalStorage(token)??'';
}

void deleteToken() {
  deleteFromLocalStorage(token);
}