import 'package:flutter/material.dart';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/blocs/search/search_tv_series_bloc.dart';
import 'package:tv_series/presentation/widgets/tv_series_card_list.dart';

class SearchTvSeriesPage extends StatelessWidget {
  const SearchTvSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Search TV Series'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                autofocus: true,
                onChanged: (query) {
                  context
                      .read<SearchTvSeriesBloc>()
                      .add(SearchTvSeriesOnQueryChanged(query));
                },
                decoration: const InputDecoration(
                  hintText: 'Search title',
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Color(0xFF211F30),
                  filled: true,
                ),
                textInputAction: TextInputAction.search,
              ),
              const SizedBox(height: 16),
              Text(
                'Search Result',
                style: kHeading6,
              ),
              BlocBuilder<SearchTvSeriesBloc, SearchTvSeriesState>(
                builder: (_, state) {
                  if (state is SearchTvSeriesLoading) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is SearchTvSeriesHasData) {
                    final result = state.result;
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final tvSeries = result[index];
                          return TvSeriesCardList(tvSeries: tvSeries);
                        },
                        itemCount: result.length,
                      ),
                    );
                  } else if (state is SearchTvSeriesEmpty) {
                    return Container(
                      margin: const EdgeInsets.only(top: 32),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 72),
                            const SizedBox(height: 2),
                            Text('Search Not Found', style: kSubtitle),
                          ],
                        ),
                      ),
                    );
                  } else if (state is SearchTvSeriesError) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          state.message,
                          key: const Key('error_message'),
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Container(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
