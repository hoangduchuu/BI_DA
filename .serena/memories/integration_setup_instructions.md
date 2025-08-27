# Integration Setup - Step by Step Instructions

## 🚀 EXECUTE THESE COMMANDS NOW

### Terminal 1: Start Docker Backend
```bash
cd /Users/huu/Documents/BI_DA
docker-compose up -d
docker-compose ps
docker-compose logs -f backend
```

### Terminal 2: Start ngrok
```bash
ngrok http 8080
```
**📋 COPY THE HTTPS URL!** (e.g., https://abc123.ngrok-free.app)

### Step 3: Update API Client
Edit file: `packages/api_client/lib/src/api_client.dart`
Line 5: Replace with YOUR ngrok URL:

**From:**
```dart
static const String baseUrl = 'https://3f3d8a3a8bb0.ngrok-free.app/api/v1';
```

**To:**
```dart
static const String baseUrl = 'https://YOUR_NGROK_URL.ngrok-free.app/api/v1';
```

### Terminal 3: Test API
```bash
# Replace YOUR_NGROK_URL with actual URL
curl https://YOUR_NGROK_URL.ngrok-free.app/api/v1/health

curl -X POST https://YOUR_NGROK_URL.ngrok-free.app/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"password123"}'
```

### Terminal 4: Run Flutter App
```bash
cd /Users/huu/Documents/BI_DA/apps/staff_app
flutter clean && flutter pub get
flutter run -d chrome
```

## 🧪 Create API Test File

Create file: `apps/staff_app/lib/features/api_test_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:api_client/api_client.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({Key? key}) : super(key: key);

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final ApiClient _apiClient = ApiClient.instance;
  String _result = '';
  bool _loading = false;

  Future<void> _testLogin() async {
    setState(() {
      _loading = true;
      _result = 'Testing login...';
    });

    try {
      final result = await _apiClient.login('admin', 'password123');
      setState(() {
        _result = 'Login successful!\nToken: ${result['accessToken']?.toString().substring(0, 50)}...';
      });
    } catch (e) {
      setState(() {
        _result = 'Login failed: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _testCompanies() async {
    setState(() {
      _loading = true;
      _result = 'Testing companies...';
    });

    try {
      final companies = await _apiClient.getCompanies();
      setState(() {
        _result = 'Companies loaded: ${companies.length} found\n${companies.map((c) => c['name']).join(', ')}';
      });
    } catch (e) {
      setState(() {
        _result = 'Companies failed: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Integration Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Testing API integration with backend',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loading ? null : _testLogin,
              icon: const Icon(Icons.login),
              label: const Text('Test Login (admin/password123)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _loading ? null : _testCompanies,
              icon: const Icon(Icons.business),
              label: const Text('Test Companies (Requires Login)'),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      child: Text(
                        _result.isEmpty 
                          ? 'Ready to test!\n\n1. Click "Test Login" first\n2. Then try "Test Companies"' 
                          : _result,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

## 🔧 Update main.dart to show test screen

Update `apps/staff_app/lib/main.dart` to import and show ApiTestScreen:

Add this import at top:
```dart
import 'features/api_test_screen.dart';
```

Add this in the home property or replace existing content:
```dart
home: const ApiTestScreen(),
```

## ✅ Expected Results

1. Docker containers running ✅
2. ngrok tunnel active ✅
3. Health check returns JSON ✅
4. Login returns JWT token ✅
5. Flutter app shows API test screen ✅
6. Login test works ✅
7. Companies test works ✅

## 🚨 Troubleshooting

If login fails:
- Check ngrok URL is correct in api_client.dart
- Verify Docker backend is running
- Check backend logs: `docker-compose logs -f backend`

If companies fail:
- Must login first to get JWT token
- Check authentication in backend logs

## 📊 Success Metrics

- Health check: 200 OK
- Login: Returns accessToken
- Companies: Returns array of companies
- Flutter: No compilation errors
- API calls: Successful responses in Flutter app