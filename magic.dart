import 'dart:collection';
import 'dart:math';
import 'dart:io';

// Fungsi utama
void main() {
  SlotMachine slotMachine = SlotMachine();
  slotMachine.displayMenu();
}

// Kelas SlotMachine
class SlotMachine {
  // Menggunakan List untuk menyimpan simbol slot
  List<String> symbols = ['🍒', '🍋', '🍊', '🍉', '⭐', '🔔'];
  
  // Menggunakan Set untuk menyimpan simbol kemenangan unik
  Set<String> winningSymbols = {'⭐', '🔔'};
  
  // Menggunakan Map untuk menyimpan nilai setiap simbol (diperbarui untuk nilai lebih rendah)
  Map<String, int> symbolValues = {
    '🍒': 15,
    '🍋': 25,
    '🍊': 35,
    '🍉': 45,
    '⭐': 60,
    '🔔': 80
  };
  
  // Menggunakan Queue untuk menyimpan hasil putaran
  Queue<List<String>> spinHistory = Queue<List<String>>();
  
  // Biaya untuk satu kali spin (diperbarui untuk biaya lebih tinggi)
  final int spinCost = 75;
  
  // Uang yang dimasukkan oleh pengguna
  int balance = 0;
  
  // Menampilkan menu
  void displayMenu() {
    while (true) {
      print('\n=== Slot Machine ===');
      print('1. Masukkan uang');
      print('2. Spin');
      print('3. View Spin History');
      print('4. Exit');
      stdout.write('Pilih opsi: ');
      String? choice = stdin.readLineSync();
      
      switch (choice) {
        case '1':
          addMoney();
          break;
        case '2':
          spin();
          break;
        case '3':
          viewSpinHistory();
          break;
        case '4':
          exit(0);
        default:
          print('Opsi tidak valid, coba lagi.');
      }
    }
  }
  
  // Fungsi untuk menambahkan uang
  void addMoney() {
    stdout.write('Masukkan jumlah uang: ');
    String? input = stdin.readLineSync();
    if (input != null && int.tryParse(input) != null) {
      int amount = int.parse(input);
      balance += amount;
      print('Saldo Anda sekarang: \$${balance}');
    } else {
      print('Input tidak valid.');
    }
  }
  
  // Fungsi untuk memutar slot
  void spin() {
    if (balance < spinCost) {
      print('Uang Anda tidak cukup. Tambahkan lebih banyak uang untuk memutar.');
      return;
    }
    
    balance -= spinCost;
    List<String> result = List.generate(3, (_) => generateSymbol());
    spinHistory.add(result);
    print('Hasil spin: ${result.join(' ')}');
    
    // Cek apakah ada simbol kemenangan
    int totalScore = 0;
    for (var symbol in result) {
      if (winningSymbols.contains(symbol)) {
        totalScore += symbolValues[symbol]!;
      }
    }
    print('Keuntungan: $totalScore');
    
    // Menambahkan skor ke saldo
    balance += totalScore;
    print('Saldo Anda sekarang: \$${balance}');
  }
  
  // Fungsi untuk mengenerate simbol dengan probabilitas lebih rendah untuk simbol kemenangan
  String generateSymbol() {
    int rand = Random().nextInt(100);
    if (rand < 25) return '🍒';
    if (rand < 45) return '🍋';
    if (rand < 65) return '🍊';
    if (rand < 80) return '🍉';
    if (rand < 90) return '⭐';
    return '🔔';
  }
  
  // Fungsi untuk melihat riwayat spin
  void viewSpinHistory() {
    if (spinHistory.isEmpty) {
      print('Belum ada riwayat spin.');
    } else {
      print('Riwayat Spin:');
      for (var spin in spinHistory) {
        print(spin.join(' '));
      }
    }
  }
}
