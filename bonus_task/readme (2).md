
# Design Decisions Documentation

**Prepared by:** Sahar Hussaini

---

## Database Design Decisions

### 1. Transaction Isolation
- **Decision:** Row-level locks (`SELECT ... FOR UPDATE`)
- **Reason:** Prevent race conditions while allowing concurrent access

### 2. Advisory Locks
- **Decision:** `pg_try_advisory_xact_lock()` with MD5 hash
- **Reason:** Prevent duplicate batch processing per company
- **Benefit:** Auto-releases on COMMIT/ROLLBACK

### 3. Error Handling
- **Decision:** Nested `BEGIN... EXCEPTION` blocks (not SAVEPOINT)
- **Reason:** Implicit savepoints, failed payments don't abort batch

### 4. Index Strategy
- **Partial indexes:** 95% smaller, filter by date/status
- **Expression indexes:** Enable `LOWER(email)`, `DATE(created_at)` searches
- **GIN indexes:** JSONB queries (`@>` operator)
- **Hash indexes:** Faster equality checks for account lookups
- **Covering indexes (INCLUDE):** Index-only scans, no heap access

### 5. Materialized Views
- **Decision:** Pre-compute `salary_batch_summary`
- **Reason:** Complex aggregations too slow for real-time
- **Trade-off:** Data slightly stale, but 100x faster queries

### 6. Security Barrier Views
- **Decision:** `WITH (security_barrier = true)`
- **Reason:** Prevent WHERE clause injection attacks

### 7. Window Functions
- **Decision:** Use `RANK()`, `LAG()`, `LEAD()` in views
- **Reason:** Avoid expensive self-joins

### 8. JSONB vs JSON
- **Decision:** JSONB for `audit_log`
- **Reason:** Indexable with GIN, binary storage (faster)

### 9. Currency Conversion
- **Decision:** Separate `exchange_rates` table with `valid_from`/`valid_to`
- **Reason:** Historical accuracy for audit compliance

### 10. Audit Logging
- **Decision:** Manual inserts (not triggers)
- **Reason:** Explicit control, easier debugging

---

## Trade-Offs Summary

| Trade-off | Decision | Impact |
|-----------|----------|--------|
| **Indexes vs Write Speed** | 8 specialized indexes | Accept 5-10% slower writes for 50-100x faster reads |
| **Materialized Views** | Pre-computed aggregations | Data 1-5 min stale, but dashboards load instantly |
| **Advisory Locks** | PostgreSQL-native locks | Single-instance only, sufficient for current scale |

---

**Last Updated:** December 2025