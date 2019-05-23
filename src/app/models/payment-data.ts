
export interface PaymentData {
    step: number,
    action: string,
    amount: number,
    amount_real: number,
    nameOrig: string,
    place: string,
    date: string,
    datetime: string,
    verwendungszweck: string,
    oldBalanceOrig: number,
    newBalanceOrig: number,
    nameDest: string,
    oldBalanceDest: number,
    newBalanceDest: number,
    isFraud: number,
    isFlaggedFraud: number,
    isUnauthorizedOverdraft: number,
    datetime_timestamp: string
}