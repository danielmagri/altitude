import 'package:altitude/common/view/generic/skeleton.dart';
import 'package:altitude/presentation/habits/controllers/habit_details_controller.dart';
import 'package:flutter/material.dart'
    show
        BuildContext,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        FontWeight,
        Key,
        Padding,
        SizedBox,
        StatelessWidget,
        Text,
        TextSpan,
        TextStyle,
        Widget;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class CoolDataWidget extends StatelessWidget {
  CoolDataWidget({Key? key})
      : controller = GetIt.I.get<HabitDetailsController>(),
        super(key: key);

  final HabitDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return controller.habit.handleState(
          loading: () {
            return const Skeleton(
              width: double.maxFinite,
              height: 130,
              margin: EdgeInsets.symmetric(horizontal: 8),
            );
          },
          success: (data) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 6, bottom: 6, left: 8),
                    child: Text(
                      'Informações Legais',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: controller.habitColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          height: 1.2,
                          fontFamily: 'Montserrat',
                        ),
                        children: <TextSpan>[
                          const TextSpan(text: 'Começou em '),
                          TextSpan(
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                            text: data!.initialDate!.day
                                    .toString()
                                    .padLeft(2, '0') +
                                '/' +
                                data.initialDate!.month
                                    .toString()
                                    .padLeft(2, '0') +
                                '/' +
                                data.initialDate!.year.toString() +
                                '\n',
                          ),
                          TextSpan(
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                            text: data.daysDone.toString(),
                          ),
                          const TextSpan(text: ' dias cumpridos no total'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
