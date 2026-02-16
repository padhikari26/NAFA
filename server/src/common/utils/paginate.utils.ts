export async function paginateAndFilter<T>(
    model: any,
    filters: Record<string, any>,
    searchFields: string[] = [],
    baseQuery: any = {},
    allowedFilterFields: string[] = []
): Promise<{
    data: T[];
    total: number;
    totalPages: number;
    page: number;
    limit: number;
    next: boolean;
}> {
    const {
        page = 1,
        limit = 10,
        search = '',
        sort = 'createdAt',
        order = 'desc',
        ...restFilters
    } = filters;

    const query: any = { ...baseQuery };

    // Add search
    if (search && searchFields.length > 0) {
        query.$or = searchFields.map((field) => ({
            [field]: { $regex: search, $options: 'i' },
        }));
    }


    for (const key of allowedFilterFields) {
        if (restFilters[key] !== undefined) {
            query[key] = restFilters[key];
        }
    }

    const skip = (page - 1) * limit;

    const [results, total] = await Promise.all([
        model
            .find(query)
            .skip(skip)
            .limit(limit)
            .sort({ [sort]: order === 'desc' ? -1 : 1 })
            .exec(),
        model.countDocuments(query),
    ]);

    return {
        data: results,
        total,
        totalPages: Math.ceil(total / limit),
        page,
        limit,
        next: total > page * limit,
    };
}
