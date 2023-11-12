// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:equatable/equatable.dart';

///
class PoolerConfig with EquatableMixin {
  factory PoolerConfig.fromMap(Map<String, dynamic> map) {
    return PoolerConfig(
      publicKey: map['pub_key'],
      transactionReference: map['transaction_reference'],
      amount: map['amount'],
      redirectLink: map['redirect_link'],
      email: map['email'],
    );
  }

  factory PoolerConfig.fromJson(String source) =>
      PoolerConfig.fromMap(json.decode(source));

  ///
  const PoolerConfig({
    required this.publicKey,
    required this.transactionReference,
    required this.redirectLink,
    required this.amount,
    required this.email,
  });

  /// Your public key an be found on your dashboard settings
  final String publicKey;

  /// Current transaction reference
  final String transactionReference;

  /// The amount you intend to send and must be pass as an integer in kobo
  final int amount;

  /// The currency of the `amount` to be paid
  final String redirectLink;

  /// User Email
  final String email;

  ///
  bool get isProd => publicKey.contains('test') == false;

  ///
  PoolerConfig copyWith({
    String? publicKey,
    String? transactionReference,
    String? redirectLink,
    String? receiptUrl,
    String? email,
    int? amount,
  }) {
    return PoolerConfig(
      publicKey: publicKey ?? this.publicKey,
      transactionReference: transactionReference ?? this.transactionReference,
      amount: amount ?? this.amount,
      redirectLink: redirectLink ?? this.redirectLink,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pub_key': publicKey,
      'transaction_reference': transactionReference,
      'amount': amount,
      'redirect_link': redirectLink,
      'email': email,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [
        publicKey,
        transactionReference,
        amount,
        redirectLink,
        email,
      ];
}
