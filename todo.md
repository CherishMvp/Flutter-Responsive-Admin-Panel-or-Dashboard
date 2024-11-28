#初始化数据模型

#初始化sqlite

#初始化provider

#sqlite默认行为介绍
## Conflict Algorithm

1. **rollback**: 当约束冲突发生时，当前事务将被立即回滚，命令将终止并返回一个错误代码 `SQLITE_CONSTRAINT`。如果没有活动事务，则此算法与 `ABORT` 相同。
2. **abort**: 当约束冲突发生时，不会执行回滚操作，因此事务中的前一个命令所做的更改将被保留。这是默认行为。
3. **fail**: 当约束冲突发生时，命令将终止并返回一个错误代码 `SQLITE_CONSTRAINT`。但是，事务中的前一个命令所做的更改将被保留。
4. **ignore**: 当约束冲突发生时，包含冲突的行将被忽略，而命令将继续执行。其他行将继续被插入或更新。没有错误返回。
5. **replace**: 当唯一约束冲突发生时，导致冲突的现有行将被删除，然后插入或更新当前行。命令将继续执行，没有错误返回。如果 NOT NULL 约束冲突发生，则 NULL 值将被替换为列的默认值。如果没有默认值，则使用 `ABORT` 算法。如果 CHECK 约束冲突发生，则使用 `IGNORE` 算法。

这些枚举值用于指定 SQLite 如何处理约束冲突的情况。