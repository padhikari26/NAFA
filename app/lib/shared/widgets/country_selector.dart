import 'package:country/country.dart';
import 'package:flutter/material.dart';

class CountryFormField extends FormField<Country> {
  CountryFormField({
    Key? key,
    Country? initialValue,
    FormFieldValidator<Country>? validator,
    required ValueChanged<Country> onChanged,
    String labelText = 'Country',
  }) : super(
          key: key,
          initialValue: initialValue,
          validator: validator ??
              (value) => value == null ? 'Country is required' : null,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    final selected = await showModalBottomSheet<Country>(
                      context: state.context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => _CountryBottomSheet(
                        selectedCountry: state.value,
                      ),
                    );

                    if (selected != null) {
                      state.didChange(selected);
                      onChanged(selected);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            state.hasError ? Colors.red : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.public, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.value != null
                                ? '${state.value!.flagEmoji} ${state.value!.isoShortName}'
                                : 'Select country',
                            style: Theme.of(state.context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: state.value != null
                                      ? Colors.black87
                                      : Colors.grey.shade600,
                                ),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 8),
                    child: Text(
                      state.errorText!,
                      style: Theme.of(state.context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );
}

class _CountryBottomSheet extends StatefulWidget {
  final Country? selectedCountry;
  const _CountryBottomSheet({Key? key, this.selectedCountry}) : super(key: key);

  @override
  State<_CountryBottomSheet> createState() => _CountryBottomSheetState();
}

class _CountryBottomSheetState extends State<_CountryBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> _filteredCountries = Countries.values;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = Countries.values.where((country) {
        return country.isoShortName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      'Select Country',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search countries...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _filteredCountries.length,
                  itemBuilder: (context, index) {
                    final country = _filteredCountries[index];
                    final isSelected = widget.selectedCountry == country;

                    return ListTile(
                      leading: Text(
                        country.flagEmoji,
                        style: TextStyle(
                          color: isSelected ? Colors.green : Colors.grey,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 24,
                        ),
                      ),
                      title: Text(country.isoShortName),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () => Navigator.pop(context, country),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
