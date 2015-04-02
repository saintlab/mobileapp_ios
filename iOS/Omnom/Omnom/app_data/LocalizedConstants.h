
//errors
#define kOMN_ERROR_MESSAGE_NO_INTERNET NSLocalizedString(@"ERROR_MESSAGE_NO_INTERNET", @"Нет доступа в интернет")
#define kOMN_ERROR_MESSAGE_NO_CONNECTION NSLocalizedString(@"ERROR_MESSAGE_NO_CONNECTION", @"Помехи на линии.")
#define kOMN_ERROR_MESSAGE_ORDER_CLOSED NSLocalizedString(@"ERROR_MESSAGE_ORDER_CLOSED", @"Оплата по счёту невозможна - стол уже закрыт. Попробуйте запросить счёт заново или позовите официанта.")
#define kOMN_ERROR_MESSAGE_QR_DECODE NSLocalizedString(@"ERROR_MESSAGE_QR_DECODE", @"Неверный QR-код,\nнайдите Omnom")
#define kOMN_ERROR_MESSAGE_PAYMENT_ERROR NSLocalizedString(@"ERROR_MESSAGE_PAYMENT_ERROR", @"Ваш банк отклонил платёж.\nПовторите попытку,\nдобавьте другую карту\nили оплатите наличными.")
#define kOMN_ERROR_MESSAGE_RESTAURANT_OFFLINE NSLocalizedString(@"ERROR_MESSAGE_RESTAURANT_OFFLINE", @"Прямо сейчас нет связи с кассой. Попробуйте позже или рассчитайтесь через официанта. Медленно, но иных вариантов сейчас нет.")
#define kOMN_ERROR_MESSAGE_UNKNOWN_ERROR NSLocalizedString(@"ERROR_MESSAGE_UNKNOWN_ERROR", @"Что-то пошло не так. Повторите попытку.")
#define kOMN_ERROR_MESSAGE_ENTER_PHONE_EMAIL NSLocalizedString(@"Введите почту и телефон", nil)

#define kOMN_WISH_CREATE_ERROR_TITLE NSLocalizedString(@"WISH_CREATE_ERROR_TITLE", @"Нет в продаже")
#define kOMN_WISH_CREATE_ERROR_SUBTITLE NSLocalizedString(@"WISH_CREATE_ERROR_SUBTITLE %@", @"В вашем заказе есть блюда, которые больше не продают:\n{product_list}\n\nУбрать из заказа и продолжить?")


//bar buttons
#define kOMN_BAR_BUTTON_COMPLETE_ORDERS_TEXT NSLocalizedString(@"BAR_BUTTON_COMPLETE_ORDERS_TEXT", @"Табло готовых заказов")
#define kOMN_BAR_TITLE_BUTTON_TEXT NSLocalizedString(@"BAR_TITLE_BUTTON_TEXT", @"Бар")
#define kOMN_DONE_BUTTON_TITLE NSLocalizedString(@"DONE_BUTTON_TITLE", @"Готово")

//buttons
#define kOMN_RESTAURANT_MODE_BAR_TITLE NSLocalizedString(@"RESTAURANT_MODE_BAR_TITLE", @"В бар")
#define kOMN_RESTAURANT_MODE_IN_TITLE NSLocalizedString(@"RESTAURANT_MODE_IN_TITLE", @"За стол")
#define kOMN_RESTAURANT_MODE_LUNCH_TITLE NSLocalizedString(@"RESTAURANT_MODE_LUNCH_TITLE", @"Заказ\nобеда\nв офис")
#define kOMN_RESTAURANT_MODE_TAKE_AWAY_TITLE NSLocalizedString(@"RESTAURANT_MODE_TAKE_AWAY_TITLE", @"Заказ\nна вынос")
#define kOMN_CLOSE_BUTTON_TITLE NSLocalizedString(@"CLOSE_BUTTON_TITLE", @"Закрыть")
#define kOMN_NEXT_BUTTON_TITLE NSLocalizedString(@"NEXT_BUTTON_TITLE", @"Далее")
#define kOMN_OK_BUTTON_TITLE NSLocalizedString(@"Ok", @"Ok")
#define kOMN_LUNCH_ALERT_SELECT_OFFICE_TITLE NSLocalizedString(@"LUNCH_ALERT_SELECT_OFFICE_TITLE", @"Выберите офис")
#define kOMN_LUNCH_ALERT_SELECT_DATE_TITLE NSLocalizedString(@"LUNCH_ALERT_SELECT_DATE_TITLE", @"Выберите дату")


//info
#define kOMN_PREORDER_DONE_LABEL_TEXT_1 NSLocalizedString(@"PREORDER_DONE_LABEL_TEXT_1", @"Заказ принят\nи обрабатывается")
#define kOMN_PREORDER_DONE_LABEL_TEXT_2 NSLocalizedString(@"PREORDER_DONE_LABEL_TEXT_2", @"Выбранные блюда скоро будут\nдобавлены официантом на ваш стол.")

#define kOMN_PREORDER_DONE_2GIS_LABEL_TEXT_1 NSLocalizedString(@"PREORDER_DONE_2GIS_LABEL_TEXT_1", @"Заказ принят\nи передан Роме")
#define kOMN_PREORDER_DONE_2GIS_LABEL_TEXT_2 NSLocalizedString(@"PREORDER_DONE_2GIS_LABEL_TEXT_2", @"Спасибо!")

#define kOMN_PREORDER_DONE_2GIS_SUNCITY_LABEL_TEXT_1 NSLocalizedString(@"PREORDER_DONE_2GIS_SUNCITY_LABEL_TEXT_1", @"Заказ принят\nи ожидеате оплаты")
#define kOMN_PREORDER_DONE_2GIS_SUNCITY_LABEL_TEXT_2 NSLocalizedString(@"PREORDER_DONE_2GIS_SUNCITY_LABEL_TEXT_2 %@ %@", @"Чтобы поесть, оплатите {amount_string} по ссылке\n{PREORDER_DONE_2GIS_SUNCITY_LABEL_ACTION_TEXT_2},\nуказав номер договора 5000306562\n\nОбед будет ждать вас на кухне на следующий рабочий день ориентировачно в 13:20.")
#define kOMN_PREORDER_DONE_2GIS_SUNCITY_LABEL_ACTION_TEXT_2 NSLocalizedString(@"PREORDER_DONE_2GIS_SUNCITY_LABEL_ACTION_TEXT_2", @"http://tinkoff.ru/cardtocard")

#define kOMN_MY_TABLE_ORDERS_LABEL_TEXT NSLocalizedString(@"MY_TABLE_ORDERS_LABEL_TEXT", @"Блюда на вашем столе")
#define kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT NSLocalizedString(@"WISH_RECOMMENDATIONS_LABEL_TEXT", @"Ранее вы заказывали")

#define kOMN_SEARCH_PRODUCT_HINT_TEXT NSLocalizedString(@"SEARCH_PRODUCT_HINT_TEXT", @"Увы, но такого блюда\nнет в нашем меню")

//orders
#define kOMN_NO_ORDERS_ON_TABLE_TEXT NSLocalizedString(@"NO_ORDERS_ON_TABLE_TEXT", @"На вашем столике нет счетов");
#define kOMN_ORDERS_ON_TABLE_TEXT1 NSLocalizedString(@"ORDERS_ON_TABLE_TEXT1{счёта} %ld", @"На вашем столике {orders_count} счёта")
#define kOMN_ORDERS_ON_TABLE_TEXT2 NSLocalizedString(@"ORDERS_ON_TABLE_TEXT2{счёт} %ld", @"На вашем столике {orders_count} счёт")
#define kOMN_ORDERS_ON_TABLE_TEXT3 NSLocalizedString(@"ORDERS_ON_TABLE_TEXT3{счетов} %ld", @"На вашем столике {orders_count} счетов")

//preorder
#define kOMN_TOTAL_TEXT NSLocalizedString(@"TOTAL_TEXT %@", @"Итого {total_string}")
#define kOMN_PREORDER_TITLE_BUTTON_TEXT NSLocalizedString(@"PREORDER_TITLE_BUTTON_TEXT", @"Предзаказ")

//address
#define kOMN_FEEDBACK_MAIL_SUBJECT_RESTAURANTS_ADDRESSES NSLocalizedString(@"FEEDBACK_MAIL_SUBJECT_RESTAURANTS_ADDRESSES", @"Добавьте мой адрес")
#define kOMN_RESTAURANT_ADDRESSES_ADD_ACTION_TEXT NSLocalizedString(@"RESTAURANT_ADDRESSES_ADD_ACTION_TEXT", @"Оставьте заявку")
#define kOMN_RESTAURANT_ADDRESSES_ADD_TEXT NSLocalizedString(@"RESTAURANT_ADDRESSES_ADD_TEXT %@", @"Не нашли свой офис?\n{action_text}\nЕсли заведение готово доставить к вам, то ваш офис через день появится в списке")
#define kOMN_RESTAURANT_ADDRESSES_HEADER_TEXT NSLocalizedString(@"RESTAURANT_ADDRESSES_HEADER_TEXT", @"Выберите этаж, куда доставить обед:")

//weekdays
#define kOMN_WEEKDAY_TOMORROW_FORMAT NSLocalizedString(@"WEEKDAY_TOMORROW_FORMAT %@", @"Завтра ({weekday})")
#define kOMN_WEEKDAY_SUNDAY NSLocalizedString(@"WEEKDAY_SUNDAY", @"Воскресенье")
#define kOMN_WEEKDAY_MONDAY NSLocalizedString(@"WEEKDAY_MONDAY", @"Понедельник")
#define kOMN_WEEKDAY_TUESDAY NSLocalizedString(@"WEEKDAY_TUESDAY", @"Вторник")
#define kOMN_WEEKDAY_WEDNESDAY NSLocalizedString(@"WEEKDAY_WEDNESDAY", @"Среда")
#define kOMN_WEEKDAY_THURSDAY NSLocalizedString(@"WEEKDAY_THURSDAY", @"Четверг")
#define kOMN_WEEKDAY_FRIDAY NSLocalizedString(@"WEEKDAY_FRIDAY", @"Пятница")
#define kOMN_WEEKDAY_SATURDAY NSLocalizedString(@"WEEKDAY_SATURDAY", @"Суббота")
#define kOMN_RESTAURANT_DATE_HEADER_TEXT NSLocalizedString(@"RESTAURANT_DATE_HEADER_TEXT", @"Выберите, когда надо доставить обед:")

//bar
#define kOMN_BAR_SUCCESS_TITLE1 NSLocalizedString(@"BAR_SUCCESS_TITLE1", @"Заказ принят")
#define kOMN_BAR_SUCCESS_ORDER_NUMBER_TEXT NSLocalizedString(@"BAR_SUCCESS_ORDER_NUMBER_TEXT", @"Номер заказа")
#define kOMN_BAR_SUCCESS_PIN_TEXT NSLocalizedString(@"BAR_SUCCESS_PIN_TEXT", @"Пин-код")
#define kOMN_BAR_SUCCESS_HELP_TEXT NSLocalizedString(@"BAR_SUCCESS_HELP_TEXT %@", @"Мы пригласим вас, когда заказ будет готов.\nТакже проверить готов ли ваш заказ\nможно {link_text}.")
#define kOMN_BAR_SUCCESS_HELP_ACTION_TEXT NSLocalizedString(@"BAR_SUCCESS_HELP_ACTION_TEXT", @"здесь")
#define kOMN_BAR_SUCCESS_MAIL_TEXT NSLocalizedString(@"BAR_SUCCESS_MAIL_TEXT", @"Чек об оплате отправлен на почту.")

//title
#define kOMN_RESTAURANT_ADDRESS_SELECTION_TITLE NSLocalizedString(@"RESTAURANT_ADDRESS_SELECTION_TITLE", @"Куда")
#define kOMN_RESTAURANT_DATE_SELECTION_TITLE NSLocalizedString(@"RESTAURANT_DATE_SELECTION_TITLE", @"Когда")
#define kOMN_ORDER_LUNCH_ALERT_TITLE NSLocalizedString(@"ORDER_LUNCH_ALERT_TITLE", @"Заказ обада в офис")

