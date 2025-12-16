import 'package:flutter/material.dart';
import 'package:quick/constant/colors.dart';
import 'package:quick/constant/constant.dart';
import 'package:quick/widgets/custom_button.dart';
import 'package:quick/services/inventory_service.dart';

class AddNewScreen extends StatefulWidget {
  final VoidCallback? onItemAdded;
  final VoidCallback? onNavigateBack;
  
  const AddNewScreen({super.key, this.onItemAdded, this.onNavigateBack});

  @override
  State<AddNewScreen> createState() => _AddNewScreenState();
}

class _AddNewScreenState extends State<AddNewScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _originalPriceController =
      TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Form fields
  String? _selectedCategory;
  DateTime? _selectedExpiryDate;
  bool _isListed = true;

  final List<String> _categories = const [
    'Bakery',
    'Dairy',
    'Drinks',
    'Produce',
    'Snacks',
    'Frozen',
    'Meat',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _originalPriceController.dispose();
    _sellingPriceController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Select Expiry Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: buttonColor,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedExpiryDate = picked;
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter item name';
    }
    return null;
  }

  String? _validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a category';
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter quantity';
    }
    final quantity = int.tryParse(value);
    if (quantity == null || quantity <= 0) {
      return 'Please enter a valid quantity';
    }
    return null;
  }

  String? _validatePrice(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Please enter a valid price';
    }
    return null;
  }

  String? _validateSellingPrice(String? value) {
    final error = _validatePrice(value, 'selling price');
    if (error != null) return error;

    final sellingPrice = double.tryParse(value ?? '');
    final originalPrice = double.tryParse(_originalPriceController.text);

    if (sellingPrice != null && originalPrice != null) {
      if (sellingPrice >= originalPrice) {
        return 'Selling price must be less than original price';
      }
    }
    return null;
  }

  String? _validateExpiryDate() {
    if (_selectedExpiryDate == null) {
      return 'Please select expiry date';
    }
    if (_selectedExpiryDate!.isBefore(DateTime.now())) {
      return 'Expiry date cannot be in the past';
    }
    return null;
  }

  String? _validateImageUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter image URL';
    }
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  void _calculateSellingPrice() {
    final originalPrice = double.tryParse(_originalPriceController.text);
    if (originalPrice != null && originalPrice > 0) {
      // Auto-calculate 50% discount as default
      final suggestedPrice = (originalPrice * 0.5).toStringAsFixed(0);
      _sellingPriceController.text = suggestedPrice;
      setState(() {});
    }
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate expiry date
    if (_selectedExpiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select expiry date')),
      );
      return;
    }

    // Create new inventory item
    final inventoryService = InventoryService();
    final newItem = inventoryService.createItem(
      name: _nameController.text.trim(),
      category: _selectedCategory!,
      quantity: int.parse(_quantityController.text.trim()),
      originalPrice: double.parse(_originalPriceController.text.trim()),
      sellingPrice: double.parse(_sellingPriceController.text.trim()),
      expiry: _selectedExpiryDate!,
      imageUrl: _imageUrlController.text.trim(),
      isListed: _isListed,
    );

    // Add item to inventory
    inventoryService.addItem(newItem);

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text('Success!'),
          ],
        ),
        content: const Text('Item added to your inventory successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _resetForm();
            },
            child: const Text('Add Another'),
          ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  _resetForm();
                  // Navigate to inventory tab via callback
                  if (widget.onItemAdded != null) {
                    widget.onItemAdded!();
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                child: const Text('Done'),
              ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _quantityController.clear();
    _originalPriceController.clear();
    _sellingPriceController.clear();
    _imageUrlController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedExpiryDate = null;
      _isListed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.onNavigateBack != null) {
              widget.onNavigateBack!();
            }
          },
        ),
        title: const Text(
          'Add New Item',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kdefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: buttonColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: buttonColor, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Add items near expiration to sell at discounted prices',
                        style: TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Item Name
              _buildSectionTitle('Item Details'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _nameController,
                label: 'Item Name',
                hint: 'e.g., Whole Wheat Bread',
                icon: Icons.shopping_bag_outlined,
                validator: _validateName,
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items:
                    _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: _validateCategory,
              ),
              const SizedBox(height: 16),

              // Quantity
              _buildTextField(
                controller: _quantityController,
                label: 'Quantity',
                hint: 'e.g., 5',
                icon: Icons.inventory_2_outlined,
                keyboardType: TextInputType.number,
                validator: _validateQuantity,
              ),
              const SizedBox(height: 16),

              // Expiry Date
              InkWell(
                onTap: _selectExpiryDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    errorText:
                        _selectedExpiryDate == null
                            ? _validateExpiryDate()
                            : null,
                  ),
                  child: Text(
                    _selectedExpiryDate == null
                        ? 'Select expiry date'
                        : '${_selectedExpiryDate!.day}/${_selectedExpiryDate!.month}/${_selectedExpiryDate!.year}',
                    style: TextStyle(
                      color:
                          _selectedExpiryDate == null
                              ? Colors.grey.shade600
                              : Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Pricing
              _buildSectionTitle('Pricing'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _originalPriceController,
                label: 'Original Price (Rs)',
                hint: 'e.g., 450',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) => _validatePrice(value, 'original price'),
                onChanged: (_) => _calculateSellingPrice(),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _sellingPriceController,
                label: 'Selling Price (Rs)',
                hint: 'e.g., 250',
                icon: Icons.sell_outlined,
                keyboardType: TextInputType.number,
                validator: _validateSellingPrice,
                helperText: 'Auto-calculated as 50% discount',
              ),
              if (_originalPriceController.text.isNotEmpty &&
                  _sellingPriceController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _buildDiscountInfo(),
                ),
              const SizedBox(height: 24),

              // Image
              _buildSectionTitle('Image'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _imageUrlController,
                label: 'Image URL',
                hint: 'https://example.com/image.jpg',
                icon: Icons.image_outlined,
                validator: _validateImageUrl,
                helperText: 'Enter a valid image URL',
              ),
              const SizedBox(height: 16),

              // Image Preview
              if (_imageUrlController.text.isNotEmpty)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageUrlController.text,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => const Center(
                            child: Icon(Icons.broken_image, size: 48),
                          ),
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Additional Info
              _buildSectionTitle('Additional Information'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description (Optional)',
                hint: 'Add any additional details about the item...',
                icon: Icons.description_outlined,
                maxLines: 3,
                validator: null,
              ),
              const SizedBox(height: 16),

              // Listing Toggle
              SwitchListTile(
                title: const Text('List for sale immediately'),
                subtitle: const Text('Item will be visible to buyers'),
                value: _isListed,
                onChanged: (value) {
                  setState(() {
                    _isListed = value;
                  });
                },
                activeColor: buttonColor,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),

              // Submit Button
              GestureDetector(
                onTap: _onSubmit,
                child: CustomButton(
                  buttonName: 'Add to Inventory',
                  buttonColor: buttonColor,
                ),
              ),
              const SizedBox(height: 16),

              // Cancel Button
              Center(
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState != null) {
                      final hasData =
                          _nameController.text.isNotEmpty ||
                          _quantityController.text.isNotEmpty ||
                          _originalPriceController.text.isNotEmpty;

                      if (hasData) {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Discard changes?'),
                                content: const Text(
                                  'Are you sure you want to discard this item?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close dialog
                                      if (widget.onNavigateBack != null) {
                                        widget.onNavigateBack!();
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Discard'),
                                  ),
                                ],
                              ),
                        );
                      } else {
                        if (widget.onNavigateBack != null) {
                          widget.onNavigateBack!();
                        }
                      }
                    }
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? helperText,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
        helperText: helperText,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged ?? (value) => setState(() {}),
    );
  }

  Widget _buildDiscountInfo() {
    final originalPrice = double.tryParse(_originalPriceController.text);
    final sellingPrice = double.tryParse(_sellingPriceController.text);

    if (originalPrice == null || sellingPrice == null) {
      return const SizedBox.shrink();
    }

    final discount = ((originalPrice - sellingPrice) / originalPrice * 100);
    final savings = originalPrice - sellingPrice;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.discount, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${discount.toStringAsFixed(0)}% discount',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                Text(
                  'Buyers save Rs ${savings.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
