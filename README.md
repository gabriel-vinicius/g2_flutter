# Projeto G2 - Matriz de Eisenhower

Aplicativo Flutter para gerenciamento de tarefas utilizando a Matriz de Eisenhower.

## 🏗️ Arquitetura

O projeto segue a arquitetura MVVM (Model-View-ViewModel) recomendada pela documentação oficial do Flutter:

```
lib/
├── core/                  # Código compartilhado
│   ├── di/               # Injeção de dependências (GetX)
│   ├── routes/           # Navegação
│   └── utils/            # Utilitários (Either, Failures)
├── data/                 # Camada de dados
│   ├── models/           # Modelos de dados
│   ├── services/         # Serviços (Firebase)
│   └── repositories/     # Repositórios (interface + implementação)
├── features/             # Features da aplicação
│   ├── auth/            # Autenticação
│   │   ├── view/        # Telas
│   │   └── viewmodel/   # Lógica de negócio
│   └── tasks/           # Tarefas
│       ├── view/        # Telas
│       └── viewmodel/   # Lógica de negócio
└── shared/              # Widgets compartilhados
```

## 🔧 Tecnologias

- **Flutter 3.4+**
- **GetX** - Gerenciamento de estado e injeção de dependências
- **Firebase** - Backend e autenticação
  - Firebase Auth (autenticação anônima)
  - Cloud Firestore (persistência de dados)

## 📋 Funcionalidades

- ✅ Login anônimo
- ✅ Criação de tarefas
- ✅ Classificação pela Matriz de Eisenhower:
  - 🔴 Urgente e Importante (Fazer)
  - 🔵 Não Urgente e Importante (Agendar)
  - 🟠 Urgente e Não Importante (Delegar)
  - ⚪ Não Urgente e Não Importante (Eliminar)
- ✅ Data e hora de prazo
- ✅ Data e hora de criação
- ✅ Marcar como concluída
- ✅ Excluir tarefas
- ✅ Filtrar por quadrante

## 🚀 Como configurar

### 1. Configurar Firebase

```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar projeto Firebase
flutterfire configure --project=seu-projeto-firebase
```

Isso criará o arquivo `lib/firebase_options.dart` automaticamente.

### 2. Configurar regras do Firestore

No Firebase Console > Firestore > Rules, adicione:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/tasks/{taskId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 3. Instalar dependências

```bash
flutter pub get
```

### 4. Executar

```bash
flutter run
```

## 📱 Telas

### Login
- Autenticação anônima no Firebase

### Lista de Tarefas
- Visualização de todas as tarefas
- Ordenação automática por quadrante e prazo
- Filtro por quadrante da Matriz de Eisenhower
- Marcar/desmarcar como concluída
- Excluir tarefas

### Formulário de Tarefas
- Título
- Seleção de quadrante (Matriz de Eisenhower)
- Data do prazo (opcional)
- Hora do prazo (opcional)

## 🎓 Princípios Aplicados

### 1. Separação de Responsabilidades
- **View**: Apenas widgets e UI
- **ViewModel**: Lógica de negócio e gerenciamento de estado
- **Repository**: Abstração da camada de dados
- **Service**: Integração com APIs externas

### 2. Inversão de Dependência
- Repositories definem interfaces (contratos)
- Implementações são injetadas via GetX

### 3. Injeção de Dependências
- Todas as dependências são gerenciadas pelo `AppBindings`
- Ciclo de vida controlado (permanent, lazy)

### 4. Arquitetura Limpa
- Camadas independentes
- Fácil de testar
- Fácil de manter

## 📚 Documentação de Referência

- [Flutter App Architecture](https://docs.flutter.dev/app-architecture)
- [UI Layer](https://docs.flutter.dev/app-architecture/case-study/ui-layer)
- [Data Layer](https://docs.flutter.dev/app-architecture/case-study/data-layer)
- [Dependency Injection](https://docs.flutter.dev/app-architecture/case-study/dependency-injection)
- [GetX Documentation](https://pub.dev/packages/get)
- [Firebase Flutter Documentation](https://firebase.flutter.dev/)

## 🐛 Solução de Problemas

### Firebase não conecta
Certifique-se de ter executado `flutterfire configure` e que o arquivo `firebase_options.dart` existe.

### Erro de autenticação
Verifique se o Firebase Auth está habilitado no console e se a autenticação anônima está ativada.

### Erro ao salvar tarefas
Verifique as regras do Firestore conforme descrito na seção de configuração.
