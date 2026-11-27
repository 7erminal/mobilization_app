class ApiPaths{
  static const msysConsultBaseUrl = "https://app.msysconsultgh.com";

  // API
  static const apiBaseUrl = "$msysConsultBaseUrl/v1/agent/api";
  static const authBaseUrl = "$msysConsultBaseUrl/v1/auth";
  static const authlessBaseUrl = "$msysConsultBaseUrl/v1/req";

  // Data bundles
  // Get Bundles
  static const getPaymentMethods = "$apiBaseUrl/get-payment-methods";
  static const getBundles = "$apiBaseUrl/get-data-bundles";
  static const buyBundle = "$apiBaseUrl/buy-data-bundle";
  static const buyAirtime = "$apiBaseUrl/buy-airtime";
  static const accountQuery = "$apiBaseUrl/account-query";
  static const ghanaWaterAccountQuery = "$apiBaseUrl/ghana-water-account-query";
  static const payDSTV = "$apiBaseUrl/pay-dstv";
  static const payGOTV = "$apiBaseUrl/pay-gotv";
  static const payECG = "$apiBaseUrl/pay-ecg";
  static const payWater = "$apiBaseUrl/pay-water";
  static const payStartimes = "$apiBaseUrl/pay-startimes";
  static const transactionStatus = "$apiBaseUrl/get-transaction-by-reference";
  static const getCorporatives = "$authlessBaseUrl/get-corporatives";
  static const login = "$authBaseUrl/user/login";
  static const refreshAccessToken = "$authBaseUrl/refresh-user-access-token";
  static const resetPassword = "$authBaseUrl/reset-password";
  static const changePassword = "$apiBaseUrl/change-password";
  static const register = "$authBaseUrl/register-user";
  static const customerAccounts = "$apiBaseUrl/get-customer-accounts";
  static const accountBalance = "$apiBaseUrl/account-balance";
  static const accountDetails = "$apiBaseUrl/account-details";
  static const nameInquiry = "$apiBaseUrl/name-inquiry";
  static const resetPin = "$apiBaseUrl/reset-pin";
  static const userDetails = "$apiBaseUrl/get-user-details";
  static const customerAccountHistory = "$apiBaseUrl/get-customer-account-history";
  static const customerAccountStatement = "$apiBaseUrl/get-customer-account-statement";
  static const customertransactionHistory = "$apiBaseUrl/get-biller-transaction-history";
  static const agentTransactions = "$apiBaseUrl/get-agent-transactions";
  static const deposit = "$apiBaseUrl/deposit";
  static const loanRepayment = "$apiBaseUrl/loan-repayment";
  static const withdrawal = "$apiBaseUrl/withdrawal";
  static const loanList = "$apiBaseUrl/list-account-loans";
  // static const customerAccountStatement = "$apiBaseUrl/get-customer-account-statement";
  static const createAccount = "$apiBaseUrl/register-account";
  static const registerUser = "$authBaseUrl/register-user";
  // static String customerAccountHistory({required String accountNumber}) => "$apiBaseUrl/get-customer-account-history/$accountNumber";
}