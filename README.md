# Keyboard-Shop-Distributed-DBMS

This is a distributed database management system made for a keyboard shop. There are two sites.

---

### Fragmentation

Horizontal:
| Relation | Site 1 | Site 2 |
|----------|--------|--------|
| Color | `val=0 or val=16777215` | - |
| Customer | `city=1` | - |
| Keyboard | `price>8000` | - |
| Kit | `colid=1 or colid=2` | - |
| Layout | `percent<80` | - |
| Switch | `colid=3 or colid=6` | - |

Vertical:
<table>
  <thead>
    <tr>
      <th>Relation</th>
      <th>Site 1</th>
      <th>Site 2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Order</td>
      <td>oid, quantity, price</td>
      <td>oid, cid, kbid, date</td>
    </tr>
    <tr>
      <td rowspan="2">Switch</td>
      <td>sid, colid</td>
      <td rowspan="2">sid, colid</td>
    </tr>
    <tr>
      <td>sid, name, manufacturer, quantity</td>
    </tr>
  </tbody>
</table>

---

### File Information
| Prefix | Description |
| ------ | ----------- |
| `site<X>_` | Files should be run at site `X`. These files contain site-specific utilities. |
| `x_` | Files can be run at both sites. These files contain general utilities. |
| `op_` | Files can be run at both sites. These files contain operations that can be performed. |

### Running
Execution order of file types:
1. init
2. views
3. triggers
4. packages

