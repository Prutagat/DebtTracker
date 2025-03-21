# DebtTracker

DebtTracker - это приложение для управления долгами, позволяющее пользователям отслеживать свои долги и кредиты.

## Основные возможности

- Добавление, редактирование и удаление записей о долгах.
- Ведение информации о заемщиках.
- Поиск пользователей по имени или электронной почте.
- Отображение информации о долгах в удобном формате.
- Аутентификация пользователей и управление темами.

## Технологии

- SwiftUI для интерфейса пользователя.
- Firebase Authentication для регистрации и авторизации.
- Firebase Firestore для хранения данных.
- Swift для основной логики приложения.

## Установка

1. Убедитесь, что у вас установлена последняя версия Xcode.
2. Клонируйте репозиторий:
    ```sh
    git clone https://github.com/yourusername/debttracker.git
    ```
3. Перейдите в директорию проекта:
    ```sh
    cd debttracker
    ```
4. Установите зависимости, если они необходимы (например, через CocoaPods или Swift Package Manager).

## Запуск проекта

1. Откройте проект в Xcode:
    ```sh
    open DebtTracker.xcodeproj
    ```
2. Убедитесь, что выбран нужный симулятор или подключенное устройство.
3. Запустите проект, нажав на кнопку "Run" или используя сочетание клавиш `Cmd + R`.

## Структура проекта

### Основные файлы

- `AppState.swift`: Содержит состояние приложения и управляет глобальными состояниями.
- `DebtTrackerApp.swift`: Точка входа в приложение.
- `MainView.swift`: Главный экран приложения после авторизации.

### Менеджеры

- `ThemeManager.swift`: Управляет темами приложения.
- `FaceIDManager.swift`: Обрабатывает аутентификацию с помощью Face ID.
- `DebtManager.swift`: Управляет получением текущих долгов (мои, мне, архивные).

### Сервисы

- `AuthenticationService.swift`: Управляет аутентификацией пользователей.
- `DebtService.swift`: Сервис для управления долгами.
- `UserService.swift`: Сервис для управления пользователями.
- `CurrencyRateService.swift`: Сервис для работы с курсами валют.

### Стили

- `CustomButtonStyle.swift`: Настраиваемый стиль для кнопок.
- `CustomTextFieldStyle.swift`: Настраиваемый стиль для текстовых полей.
- `CustomTextStack.swift`: Настраиваемый стек текстовых элементов.
- `CustomTextFieldStack.swift`: Стек для текстовых полей с настройками.
- `CustomTextButton.swift`: Текст с кнопкой и изображением.
- `CustomCurrencyRepresentationStyle.swift`: Стиль для представления валюты.
- `CustomHeaderSection.swift`: Настраиваемый заголовок секции.

### Модели

- `Debt.swift`: Модель долга.
- `Profile.swift`: Модель профиля пользователя.

### Виды (Views)

#### AuthorizationFlow

- `AuthorizationView.swift`: Входная точка для авторизации.
- `SignInView.swift`: Экран входа.
- `SignUpView.swift`: Экран регистрации.

#### Debts

- `DebtsView.swift`: Главный экран с долгами.
- `CurrencyRateSection.swift`: Секция для отображения курса валют.

#### Debt

- `DebtSection.swift`: Секция для отображения долгов.
- `DebtList.swift`: Список долгов.
- `DebtRow.swift`: Отдельная строка с информацией о долге.
- `DebtDetail.swift`: Подробная информация о долге.
- `DebtEditor.swift`: Экран редактирования долга.
- `UserSearchView.swift`: Экран поиска пользователей.

#### Other

- `OtherSection.swift`: Другая секция.
- `OtherRow.swift`: Другая строка.

#### Statistics

- `StatisticsView.swift`: Экран с общей статистикой.
- `DebitCreditSection.swift`: Секция дебета и кредита.
- `SectorMarkView.swift`: Вид для отображения секторальной метки.

#### Profile

- `ProfileView.swift`: Экран профиля пользователя.

#### Settings

- `SettingsView.swift`: Экран настроек приложения.

### Локализация

- `Localized.swift`: Файл для работы с локализацией.
- `Localizable.strings`: Файл локализации строк.
- `InfoPlist.strings`: Файл локализации информационного plist.


## Вклад в проект

1. Форкните репозиторий.
2. Создайте новую ветку для ваших изменений:
    ```sh
    git checkout -b feature/my-new-feature
    ```
3. Внесите изменения и закоммитьте их:
    ```sh
    git commit -am 'Add some feature'
    ```
4. Отправьте изменения в удаленный репозиторий:
    ```sh
    git push origin feature/my-new-feature
    ```
5. Создайте Pull Request.
