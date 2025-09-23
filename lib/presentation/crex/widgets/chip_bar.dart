import 'package:flutter/material.dart';

class ChipBar extends StatefulWidget {
  final List<String> items;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? height;

  const ChipBar({
    Key? key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.height,
  }) : super(key: key);

  @override
  State<ChipBar> createState() => _ChipBarState();
}

class _ChipBarState extends State<ChipBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 50,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final isSelected = index == widget.selectedIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => widget.onItemSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (widget.selectedColor ?? const Color(0xFF0EA5E9))
                      : (widget.unselectedColor ?? Colors.transparent),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? (widget.selectedColor ?? const Color(0xFF0EA5E9))
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.items[index],
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : const Color(0xFF94A3B8),
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// lib/presentation/crex/widgets/chip_bar.dart

// class ChipBar extends ConsumerWidget {
//   const ChipBar({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final value = ref.watch(matchTypeProvider);
//     final types = const ['international','league','domestic','women'];
//     final labels = const ['All','League','Domestic','Women'];
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(types.length, (i) {
//           final selected = value == types[i];
//           return Padding(
//             padding: const EdgeInsets.only(right: 8),
//             child: ChoiceChip(
//               label: Text(labels[i]),
//               selected: selected,
//               onSelected: (_) => ref.read(matchTypeProvider.notifier).state = types[i],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
