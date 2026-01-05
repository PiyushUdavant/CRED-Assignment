import 'package:cred_application/core/strings.dart';
import 'package:cred_application/core/utils/colors.dart';
import 'package:cred_application/core/utils/text_styles.dart';
import 'package:cred_application/presentation/bloc/bills_bloc.dart';
import 'package:cred_application/presentation/widgets/bills_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillsPage extends StatefulWidget {
  final String endpoint;

  const BillsPage({super.key, required this.endpoint});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  late String _currentEndpoint;
  late bool _isMock1;

  @override
  void initState() {
    super.initState();
    _currentEndpoint = widget.endpoint;
    _isMock1 = _currentEndpoint == mock1Endpoint;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BillsBloc>().add(LoadBillsEvent(endpoint: _currentEndpoint));
      }
    });
  }

  void _toggleEndpoint() {
    setState(() {
      _isMock1 = !_isMock1;
      _currentEndpoint = _isMock1 ? mock1Endpoint : mock2Endpoint;
    });
    context.read<BillsBloc>().add(LoadBillsEvent(endpoint: _currentEndpoint));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      appBar: AppBar(
        title: Text('CRED Assignment', style: AppTextStyles.s18H120W700,),
        backgroundColor: whiteColor,
        elevation: 0,
      ),
      body: BlocBuilder<BillsBloc, BillsState>(
        builder: (context, state) {
            if (state is BillsInitial || state is BillsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BillsFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: redColor),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<BillsBloc>().add(LoadBillsEvent(endpoint: _currentEndpoint));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is BillsLoaded) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _toggleEndpoint,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: blackColor.withAlpha(26),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _isMock1 ? deepPurpleColor : transparentColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Mock1',
                                style: _isMock1 ? AppTextStyles.s14H120W600.copyWith(color: whiteColor) : AppTextStyles.s14H120W600.copyWith(color: grey600),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: !_isMock1 ? deepPurpleColor : transparentColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Mock2',
                                style: !_isMock1 ? AppTextStyles.s14H120W600.copyWith(color: whiteColor) : AppTextStyles.s14H120W600.copyWith(color: grey600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${state.billSection.title} (${state.billSection.billsCount})',
                          style: AppTextStyles.s17W700Primary,
                        ),
                        if (state.billSection.viewAllCtaTitle != null)
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              '${state.billSection.viewAllCtaTitle} >',
                              style: AppTextStyles.s12W400Secondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BillsCarousel(
                      billSection: state.billSection,
                      isMock2: !_isMock1,
                      cardHeight: 120,
                      cardMargin: 12,
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
      ),
    );
  }
}