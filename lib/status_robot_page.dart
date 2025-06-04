import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medigo/controllers/status_robot_controller.dart';
import 'package:medigo/controllers/rc_controller.dart';

class StatusRobotPage extends StatelessWidget {
  const StatusRobotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<StatusRobotController>(context);
    final rcController = Provider.of<RcController>(context);
    final modSmartphone = rcController.isOn;

    final blueAccent = Colors.blueAccent;
    final lightGrey = const Color(0xFFF0F0F0);

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: blueAccent,
        title: const Text(
          "Status Robot",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mod de Comandă',
              style: TextStyle(
                color: blueAccent.shade700,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Consumer<RcController>(
              builder: (context, rcController, _) => Row(
                children: [
                  Switch(
                    value: rcController.isOn,
                    onChanged: rcController.toggleRcSwitch,
                    activeColor: blueAccent,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    rcController.isOn ? 'Mod Smartphone' : 'Mod Automat',
                    style: TextStyle(color: blueAccent.shade400, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Zona cu cele 5 butoane (săgeți + STOP)
            Column(
              children: [
                // Săgeată sus
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (modSmartphone) {
                        controller.trimiteComanda("fata");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueAccent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.arrow_upward, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),

                // Stânga, Stop, Dreapta
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (modSmartphone) {
                          controller.trimiteComanda("stanga");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueAccent,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (modSmartphone) {
                          controller.trimiteComanda("stop");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 28,
                        ),
                      ),
                      child: const Text(
                        'STOP',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (modSmartphone) {
                          controller.trimiteComanda("dreapta");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueAccent,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Săgeată jos
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (modSmartphone) {
                        controller.trimiteComanda("spate");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueAccent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.incarcaRapoarte,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Raport Robot'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.incarcaAvarii();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Raport Avarii'),
                  ),
                ),
              ],
            ),
            Consumer<StatusRobotController>(
              builder: (context, controller, _) {
                final avarie = controller.avarieCurenta;
                if (controller.avarii.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Nicio avarie disponibilă.',
                      style: TextStyle(color: blueAccent.shade700),
                    ),
                  );
                }
                final dataOra =
                    DateTime.tryParse(
                      avarie!.timestamp,
                    )?.toLocal().toString().split('.')[0] ??
                    'Dată invalidă';
                return Card(
                  color: Colors.grey[200],
                  margin: const EdgeInsets.only(top: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Tip: ${avarie.tipAlarma}',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        Text(
                          'Descriere: ${avarie.descriere}',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        Text(
                          'Status: ${avarie.status}',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        Text(
                          'Data și ora: $dataOra',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: controller.avariePrecedenta,
                              icon: const Icon(Icons.arrow_back),
                            ),
                            Text(
                              '${controller.index + 1} / ${controller.avarii.length}',
                              style: TextStyle(color: Colors.black87),
                            ),
                            IconButton(
                              onPressed: controller.avarieUrmatoare,
                              icon: const Icon(Icons.arrow_forward),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            if (controller.loading)
              const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              ),

            if (!controller.loading && controller.rapoarte.isNotEmpty)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      controller.formatRaport(),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: controller.currentIndex > 0
                            ? controller.decrementIndex
                            : null,
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: controller.currentIndex > 0
                              ? blueAccent
                              : const Color.fromARGB(255, 12, 12, 12),
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed:
                            controller.currentIndex <
                                controller.rapoarte.length - 1
                            ? controller.incrementIndex
                            : null,
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color:
                              controller.currentIndex <
                                  controller.rapoarte.length - 1
                              ? blueAccent
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            if (!controller.loading && controller.rapoarte.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Niciun raport încă.',
                  style: TextStyle(color: blueAccent.shade400),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
