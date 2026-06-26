import '../models/role.dart';

class DefaultRoles {
  static List<Role> get all => [
        // مافیا
        Role(
          id: 'godfather',
          name: 'گاد فادر',
          description: 'رهبر مافیا که در روز بی‌گناه به نظر می‌رسد',
          ability: 'در بازجویی کارآگاه بی‌گناه نشان داده می‌شود',
          team: RoleTeam.mafia,
          type: RoleType.special,
          emoji: '🤵',
        ),
        Role(
          id: 'mafia_simple',
          name: 'مافیا ساده',
          description: 'عضو عادی مافیا',
          ability: 'هر شب با تیم مافیا یک نفر را حذف می‌کند',
          team: RoleTeam.mafia,
          emoji: '🔫',
        ),
        Role(
          id: 'nato',
          name: 'ناتو',
          description: 'تک‌تیرانداز مافیا',
          ability: 'یک بار در بازی می‌تواند در روز یک نفر را حذف کند',
          team: RoleTeam.mafia,
          type: RoleType.special,
          emoji: '🎯',
        ),
        Role(
          id: 'silencer',
          name: 'ساکت‌کننده',
          description: 'مافیایی که جلوی صحبت را می‌گیرد',
          ability: 'هر شب یک نفر را ساکت می‌کند تا فردا نتواند صحبت کند',
          team: RoleTeam.mafia,
          type: RoleType.special,
          emoji: '🤐',
        ),

        // شهروند
        Role(
          id: 'citizen',
          name: 'شهروند ساده',
          description: 'شهروند عادی بدون توانایی خاص',
          ability: 'در رأی‌گیری روزانه شرکت می‌کند',
          team: RoleTeam.citizen,
          emoji: '👤',
        ),
        Role(
          id: 'detective',
          name: 'کارآگاه',
          description: 'کارآگاه شهر که هویت افراد را بررسی می‌کند',
          ability: 'هر شب می‌تواند هویت یک نفر را بپرسد (مافیا/شهروند)',
          team: RoleTeam.citizen,
          type: RoleType.special,
          emoji: '🔍',
        ),
        Role(
          id: 'doctor',
          name: 'دکتر',
          description: 'پزشک شهر که جان افراد را نجات می‌دهد',
          ability: 'هر شب یک نفر را نجات می‌دهد (یک بار خودش)',
          team: RoleTeam.citizen,
          type: RoleType.special,
          emoji: '⚕️',
        ),
        Role(
          id: 'sniper',
          name: 'تک‌تیرانداز',
          description: 'محافظ شهر با اسلحه',
          ability: 'یک بار در بازی می‌تواند در روز شلیک کند',
          team: RoleTeam.citizen,
          type: RoleType.special,
          emoji: '🏹',
        ),
        Role(
          id: 'psychologist',
          name: 'روانشناس',
          description: 'روانشناس شهر',
          ability: 'هر شب می‌تواند تیم یک نفر را بپرسد',
          team: RoleTeam.citizen,
          type: RoleType.special,
          emoji: '🧠',
        ),
        Role(
          id: 'mayor',
          name: 'شهردار',
          description: 'شهردار با رأی مضاعف',
          ability: 'رأی او دو تا حساب می‌شود',
          team: RoleTeam.citizen,
          type: RoleType.special,
          emoji: '👑',
        ),

        // مستقل
        Role(
          id: 'joker',
          name: 'جوکر',
          description: 'بازیکن مستقل که هدفش اخراج از بازی است',
          ability: 'اگر با رأی اخراج شود برنده می‌شود',
          team: RoleTeam.independent,
          type: RoleType.special,
          emoji: '🃏',
        ),
        Role(
          id: 'serial_killer',
          name: 'قاتل زنجیره‌ای',
          description: 'قاتل مستقل که تنها بازی می‌کند',
          ability: 'هر شب یک نفر را می‌کشد و نمی‌توان کشتش',
          team: RoleTeam.independent,
          type: RoleType.special,
          emoji: '🔪',
        ),
      ];
}
